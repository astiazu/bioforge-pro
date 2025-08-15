import os
import pandas as pd
import json
from flask import render_template, request, redirect, url_for, flash, jsonify, session
from werkzeug.utils import secure_filename
from app import app

# Bio data
BIO_SHORT = "📊 Consultor freelance en Analítica de Datos y Sistemas • Formador en Python y BI • Certificado Google Data Analytics • Transformo datos en decisiones."

BIO_EXTENDED = """
Soy José Luis Astiazu, consultor independiente en análisis de datos, big data y sistemas.
Especialista en Python, Django, automatización de procesos y visualización de datos.
Certificado en Google Data Analytics. Me apasiona simplificar lo complejo y acompañar a mis clientes en todo el ciclo: desde la captura y limpieza de datos hasta la presentación de resultados claros y accionables.
📍 Mina Clavero, Córdoba – Argentina.
"""

# Publications data
PUBLICATIONS = [
    {
        "type": "Educativo",
        "title": "El error más común al analizar datos (y cómo evitarlo)",
        "content": "Muchos creen que el análisis de datos empieza en la visualización, pero la base está en la limpieza y preparación..."
    },
    {
        "type": "Caso de éxito",
        "title": "Cómo un dashboard redujo el tiempo de reportes en un 40%",
        "content": "Un cliente de retail necesitaba reportes semanales que le tomaban horas. Con un dashboard en Python + Power BI logramos..."
    },
    {
        "type": "Autoridad técnica",
        "title": "3 razones para aprender Python si trabajás con datos",
        "content": "1️⃣ Sintaxis clara 2️⃣ Librerías potentes 3️⃣ Comunidad enorme..."
    }
]

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'csv'}

@app.route('/')
def index():
    return render_template('index.html', 
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='home')

@app.route('/publications')
def publications():
    return render_template('publications.html', 
                         publications=PUBLICATIONS,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='publications')

@app.route('/portfolio')
def portfolio():
    return render_template('portfolio.html',
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='portfolio')

@app.route('/notes', methods=['GET', 'POST'])
def notes():
    if request.method == 'POST':
        note_content = request.form.get('notes', '')
        if note_content.strip():
            # Store note in session for temporary storage
            if 'notes' not in session:
                session['notes'] = []
            session['notes'].append({
                'content': note_content,
                'timestamp': pd.Timestamp.now().strftime('%Y-%m-%d %H:%M:%S')
            })
            flash('✅ Nota guardada temporalmente', 'success')
        return redirect(url_for('notes'))
    
    saved_notes = session.get('notes', [])
    return render_template('notes.html',
                         saved_notes=saved_notes,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='notes')

@app.route('/data-analysis', methods=['GET', 'POST'])
def data_analysis():
    return render_template('data_analysis.html',
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='data_analysis')

@app.route('/upload-csv', methods=['POST'])
def upload_csv():
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file selected'}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({'error': 'No file selected'}), 400
        
        if not allowed_file(file.filename):
            return jsonify({'error': 'Please upload a CSV file'}), 400
        
        # Read CSV directly from memory
        df = pd.read_csv(file)
        
        # Basic data info
        info = {
            'columns': df.columns.tolist(),
            'shape': df.shape,
            'dtypes': df.dtypes.astype(str).to_dict(),
            'preview': df.head(10).to_dict('records'),
            'missing_values': df.isnull().sum().to_dict()
        }
        
        # Store dataframe in session for analysis
        session['csv_data'] = df.to_json()
        
        return jsonify(info)
    
    except Exception as e:
        app.logger.error(f"Error processing CSV: {str(e)}")
        return jsonify({'error': f'Error processing file: {str(e)}'}), 500

@app.route('/analyze-data', methods=['POST'])
def analyze_data():
    try:
        if 'csv_data' not in session:
            return jsonify({'error': 'No data available. Please upload a CSV file first.'}), 400
        
        # Restore dataframe from session
        df = pd.read_json(session['csv_data'])
        
        data = request.get_json()
        chart_type = data.get('chart_type', 'scatter')
        x_column = data.get('x_column')
        y_column = data.get('y_column')
        
        if not x_column or not y_column:
            return jsonify({'error': 'Please select both X and Y columns'}), 400
        
        if x_column not in df.columns or y_column not in df.columns:
            return jsonify({'error': 'Selected columns not found in data'}), 400
        
        # Prepare data for Chart.js
        chart_data = {
            'labels': df[x_column].astype(str).tolist()[:100],  # Limit to first 100 points
            'datasets': [{
                'label': f'{y_column} vs {x_column}',
                'data': df[y_column].fillna(0).tolist()[:100],
                'borderColor': 'rgb(75, 192, 192)',
                'backgroundColor': 'rgba(75, 192, 192, 0.2)',
                'tension': 0.1
            }]
        }
        
        # For scatter plots, format data differently
        if chart_type == 'scatter':
            chart_data['datasets'][0]['data'] = [
                {'x': x, 'y': y} for x, y in zip(
                    df[x_column].fillna(0).tolist()[:100], 
                    df[y_column].fillna(0).tolist()[:100]
                )
            ]
        
        return jsonify({
            'chart_data': chart_data,
            'chart_type': chart_type,
            'title': f'{y_column} vs {x_column}'
        })
    
    except Exception as e:
        app.logger.error(f"Error analyzing data: {str(e)}")
        return jsonify({'error': f'Error analyzing data: {str(e)}'}), 500

@app.route('/clear-notes', methods=['POST'])
def clear_notes():
    session.pop('notes', None)
    flash('📝 Todas las notas han sido eliminadas', 'info')
    return redirect(url_for('notes'))

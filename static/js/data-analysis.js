// Data Analysis JavaScript for José Luis Astiazu Portfolio
// Handles CSV upload, processing, and chart generation

let currentData = null;
let currentChart = null;

document.addEventListener('DOMContentLoaded', function() {
    initializeDataAnalysis();
});

function initializeDataAnalysis() {
    const uploadBtn = document.getElementById('uploadBtn');
    const csvFileInput = document.getElementById('csvFile');
    const generateChartBtn = document.getElementById('generateChart');
    
    if (uploadBtn) {
        uploadBtn.addEventListener('click', handleCSVUpload);
    }
    
    if (csvFileInput) {
        csvFileInput.addEventListener('change', function() {
            if (this.files.length > 0) {
                updateUploadStatus(`Archivo seleccionado: ${this.files[0].name}`, 'info');
            }
        });
    }
    
    if (generateChartBtn) {
        generateChartBtn.addEventListener('click', generateChart);
    }
}

function handleCSVUpload() {
    const fileInput = document.getElementById('csvFile');
    const file = fileInput.files[0];
    
    if (!file) {
        updateUploadStatus('Por favor selecciona un archivo CSV', 'error');
        return;
    }
    
    if (!file.name.toLowerCase().endsWith('.csv')) {
        updateUploadStatus('Por favor selecciona un archivo CSV válido', 'error');
        return;
    }
    
    const formData = new FormData();
    formData.append('file', file);
    
    // Show loading state
    const uploadBtn = document.getElementById('uploadBtn');
    const originalText = uploadBtn.innerHTML;
    uploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Procesando...';
    uploadBtn.disabled = true;
    
    fetch('/upload-csv', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.error) {
            throw new Error(data.error);
        }
        
        currentData = data;
        displayDataPreview(data);
        setupChartConfiguration(data.columns);
        updateUploadStatus('¡Archivo procesado exitosamente!', 'success');
        
        // Show preview and configuration sections
        document.getElementById('dataPreview').style.display = 'block';
        document.getElementById('chartConfig').style.display = 'block';
        
    })
    .catch(error => {
        console.error('Error uploading file:', error);
        updateUploadStatus(error.message, 'error');
    })
    .finally(() => {
        // Reset button
        uploadBtn.innerHTML = originalText;
        uploadBtn.disabled = false;
    });
}

function updateUploadStatus(message, type) {
    const statusEl = document.getElementById('uploadStatus');
    const iconClass = type === 'success' ? 'fa-check-circle text-success' : 
                     type === 'error' ? 'fa-exclamation-circle text-danger' : 
                     'fa-info-circle text-info';
    
    statusEl.innerHTML = `<i class="fas ${iconClass} me-2"></i>${message}`;
    
    // Auto-clear after 5 seconds if it's an error or info
    if (type !== 'success') {
        setTimeout(() => {
            statusEl.innerHTML = '';
        }, 5000);
    }
}

function displayDataPreview(data) {
    // Update statistics
    document.getElementById('dataRows').textContent = data.shape[0];
    document.getElementById('dataCols').textContent = data.shape[1];
    
    // Calculate total missing values
    const totalMissing = Object.values(data.missing_values).reduce((sum, val) => sum + val, 0);
    document.getElementById('dataMissing').textContent = totalMissing;
    
    // Count unique data types
    const uniqueTypes = [...new Set(Object.values(data.dtypes))].length;
    document.getElementById('dataTypes').textContent = uniqueTypes;
    
    // Build table
    const tableHead = document.getElementById('dataTableHead');
    const tableBody = document.getElementById('dataTableBody');
    
    // Clear existing content
    tableHead.innerHTML = '';
    tableBody.innerHTML = '';
    
    // Create header
    const headerRow = document.createElement('tr');
    data.columns.forEach(col => {
        const th = document.createElement('th');
        th.textContent = col;
        th.title = `Tipo: ${data.dtypes[col]}, Faltantes: ${data.missing_values[col]}`;
        headerRow.appendChild(th);
    });
    tableHead.appendChild(headerRow);
    
    // Create rows (limit to first 10)
    data.preview.forEach(row => {
        const tr = document.createElement('tr');
        data.columns.forEach(col => {
            const td = document.createElement('td');
            const value = row[col];
            td.textContent = value !== null && value !== undefined ? value : 'N/A';
            if (value === null || value === undefined) {
                td.classList.add('text-muted');
            }
            tr.appendChild(td);
        });
        tableBody.appendChild(tr);
    });
}

function setupChartConfiguration(columns) {
    const xSelect = document.getElementById('xColumn');
    const ySelect = document.getElementById('yColumn');
    
    // Clear existing options
    xSelect.innerHTML = '<option value="">Seleccionar columna...</option>';
    ySelect.innerHTML = '<option value="">Seleccionar columna...</option>';
    
    // Add column options
    columns.forEach(col => {
        const xOption = new Option(col, col);
        const yOption = new Option(col, col);
        xSelect.add(xOption);
        ySelect.add(yOption);
    });
}

function generateChart() {
    const chartType = document.getElementById('chartType').value;
    const xColumn = document.getElementById('xColumn').value;
    const yColumn = document.getElementById('yColumn').value;
    
    if (!xColumn || !yColumn) {
        updateUploadStatus('Por favor selecciona ambas columnas (X e Y)', 'error');
        return;
    }
    
    const generateBtn = document.getElementById('generateChart');
    const originalText = generateBtn.innerHTML;
    generateBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Generando...';
    generateBtn.disabled = true;
    
    fetch('/analyze-data', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            chart_type: chartType,
            x_column: xColumn,
            y_column: yColumn
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.error) {
            throw new Error(data.error);
        }
        
        displayChart(data);
        document.getElementById('chartDisplay').style.display = 'block';
        updateUploadStatus('¡Gráfico generado exitosamente!', 'success');
        
        // Scroll to chart
        document.getElementById('chartDisplay').scrollIntoView({ 
            behavior: 'smooth',
            block: 'start' 
        });
        
    })
    .catch(error => {
        console.error('Error generating chart:', error);
        updateUploadStatus(error.message, 'error');
    })
    .finally(() => {
        generateBtn.innerHTML = originalText;
        generateBtn.disabled = false;
    });
}

function displayChart(data) {
    const ctx = document.getElementById('dataChart').getContext('2d');
    
    // Destroy existing chart
    if (currentChart) {
        currentChart.destroy();
    }
    
    // Configure chart based on type
    const config = {
        type: data.chart_type,
        data: data.chart_data,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: true,
                    text: data.title,
                    color: '#fff',
                    font: {
                        size: 16,
                        weight: 'bold'
                    }
                },
                legend: {
                    labels: {
                        color: '#fff'
                    }
                }
            },
            scales: {
                x: {
                    ticks: {
                        color: '#fff',
                        maxTicksLimit: 10
                    },
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    title: {
                        display: true,
                        text: document.getElementById('xColumn').value,
                        color: '#fff'
                    }
                },
                y: {
                    ticks: {
                        color: '#fff'
                    },
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    title: {
                        display: true,
                        text: document.getElementById('yColumn').value,
                        color: '#fff'
                    }
                }
            }
        }
    };
    
    // Special configuration for scatter plots
    if (data.chart_type === 'scatter') {
        config.options.scales.x.type = 'linear';
        config.options.scales.x.position = 'bottom';
    }
    
    currentChart = new Chart(ctx, config);
}

// Utility functions for chart styling
function getChartColors(count) {
    const colors = [
        'rgba(75, 192, 192, 0.8)',
        'rgba(255, 99, 132, 0.8)',
        'rgba(54, 162, 235, 0.8)',
        'rgba(255, 205, 86, 0.8)',
        'rgba(153, 102, 255, 0.8)',
        'rgba(255, 159, 64, 0.8)',
        'rgba(199, 199, 199, 0.8)',
        'rgba(83, 102, 255, 0.8)'
    ];
    
    return colors.slice(0, count);
}

function formatChartTooltip(context) {
    let label = context.dataset.label || '';
    if (label) {
        label += ': ';
    }
    if (context.parsed.y !== null) {
        label += new Intl.NumberFormat('es-AR').format(context.parsed.y);
    }
    return label;
}

// Export chart as image
function exportChart() {
    if (currentChart) {
        const url = currentChart.toBase64Image();
        const link = document.createElement('a');
        link.download = 'chart.png';
        link.href = url;
        link.click();
    }
}

// Clear all data and reset form
function clearAnalysis() {
    currentData = null;
    if (currentChart) {
        currentChart.destroy();
        currentChart = null;
    }
    
    document.getElementById('csvFile').value = '';
    document.getElementById('dataPreview').style.display = 'none';
    document.getElementById('chartConfig').style.display = 'none';
    document.getElementById('chartDisplay').style.display = 'none';
    document.getElementById('uploadStatus').innerHTML = '';
}

console.log('Data Analysis JavaScript initialized! 📊');

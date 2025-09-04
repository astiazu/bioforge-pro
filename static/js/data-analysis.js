// static/js/data-analysis.js
document.addEventListener('DOMContentLoaded', function () {
    const csvFile = document.getElementById('csvFile');
    const uploadBtn = document.getElementById('uploadBtn');
    const uploadStatus = document.getElementById('uploadStatus');
    const dataPreview = document.getElementById('dataPreview');
    const chartConfig = document.getElementById('chartConfig');
    const chartDisplay = document.getElementById('chartDisplay');
    const dataTableHead = document.getElementById('dataTableHead');
    const dataTableBody = document.getElementById('dataTableBody');
    const xColumn = document.getElementById('xColumn');
    const yColumn = document.getElementById('yColumn');
    const chartType = document.getElementById('chartType');
    const generateChartBtn = document.getElementById('generateChart');
    const dataChart = document.getElementById('dataChart').getContext('2d');

    let fileId = null;  // ✅ Almacenar el ID del archivo
    let chartInstance = null;

    // Subir CSV
    uploadBtn.addEventListener('click', async () => {
        const file = csvFile.files[0];
        if (!file) return showStatus('error', 'Selecciona un archivo CSV');

        const formData = new FormData();
        formData.append('file', file);

        try {
            showStatus('info', 'Procesando...');
            const response = await fetch('/upload-csv', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();
            if (response.ok) {
                // ✅ Guardar el file_id
                fileId = result.file_id;
                console.log("✅ file_id recibido:", fileId);

                showStatus('success', '¡CSV cargado!');
                renderDataPreview(result);
                setupColumnSelectors(result.columns);
                dataPreview.style.display = 'block';
                chartConfig.style.display = 'block';
            } else {
                showStatus('error', result.error || 'Error al procesar CSV');
            }
        } catch (error) {
            showStatus('error', 'Error de conexión');
            console.error(error);
        }
    });

    // Mostrar vista previa
    function renderDataPreview(info) {
        document.getElementById('dataRows').textContent = info.shape[0];
        document.getElementById('dataCols').textContent = info.shape[1];
        document.getElementById('dataMissing').textContent = Object.values(info.missing_values).reduce((a, b) => a + b, 0);
        document.getElementById('dataTypes').textContent = new Set(Object.values(info.dtypes)).size;

        // Tabla
        dataTableHead.innerHTML = '<tr>' + info.columns.map(col => `<th>${col}</th>`).join('') + '</tr>';
        dataTableBody.innerHTML = info.preview.map(row => {
            return '<tr>' + info.columns.map(col => `<td>${row[col]}</td>`).join('') + '</tr>';
        }).join('');
    }

    // Llenar selectores de columnas
    function setupColumnSelectors(columns) {
        [xColumn, yColumn].forEach(select => {
            select.innerHTML = '<option value="">Seleccionar columna...</option>';
            columns.forEach(col => {
                const option = document.createElement('option');
                option.value = col;
                option.textContent = col;
                select.appendChild(option);
            });
        });
    }

    // Generar gráfico
    generateChartBtn.addEventListener('click', async () => {
        const x = xColumn.value;
        const y = yColumn.value;
        const type = chartType.value;

        console.log("Generando gráfico:", { x, y, type });

        if (!x || !y) {
            alert('Selecciona ambas columnas');
            return;
        }

        if (!fileId) {
            alert('Primero debes subir un CSV');
            return;
        }

        try {
            const response = await fetch('/analyze-data', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    file_id: fileId,  // ✅ Enviar el file_id
                    x_column: x,
                    y_column: y,
                    chart_type: type
                })
            });

            const result = await response.json();
            console.log("Datos recibidos:", result);

            if (response.ok) {
                if (chartInstance) chartInstance.destroy();
                chartInstance = new Chart(dataChart, {
                    type: result.chart_type === 'scatter' ? 'scatter' : result.chart_type,
                    data: result.chart_data,
                    options: {
                        responsive: true,
                        plugins: {
                            title: {
                                display: true,
                                text: result.title
                            }
                        }
                    }
                });
                chartDisplay.style.display = 'block';
            } else {
                alert('Error: ' + result.error);
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Error al generar gráfico');
        }
    });

    function showStatus(type, message) {
        const classes = {
            info: 'text-info',
            success: 'text-success',
            error: 'text-danger'
        };
        uploadStatus.innerHTML = `<small class="${classes[type]}">${message}</small>`;
    }

    // === Descargar gráfico como PNG ===
    const downloadBtn = document.getElementById('downloadChart');
    if (downloadBtn) {
        downloadBtn.addEventListener('click', () => {
            if (!chartInstance) {
                alert('No hay gráfico para descargar');
                return;
            }

            // Obtener URL del gráfico (imagen PNG)
            const url = dataChart.canvas.toDataURL('image/png');

            // Crear enlace temporal para descargar
            const a = document.createElement('a');
            a.href = url;
            a.download = `grafico-${Date.now()}.png`;
            a.click();
        });
    }
});
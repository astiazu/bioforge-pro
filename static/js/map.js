// static/js/map.js

// Función para actualizar el mapa cuando el usuario ingresa una ubicación
function updateMap(location) {
    try {
        fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(location)}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`Error en la solicitud: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                if (data.length > 0) {
                    const { lat, lon } = data[0];
                    map.setView([lat, lon], 13);
                    map.eachLayer(layer => {
                        if (layer instanceof L.Marker) {
                            map.removeLayer(layer); // Eliminar marcadores anteriores
                        }
                    });
                    L.marker([lat, lon]).addTo(map).bindPopup(location).openPopup();
                } else {
                    console.warn("No se encontraron coordenadas para la ubicación:", location);
                }
            })
            .catch(error => {
                console.error("Error procesando la respuesta de la API:", error);
            });
    } catch (error) {
        console.error("Error en la función updateMap:", error);
    }
}
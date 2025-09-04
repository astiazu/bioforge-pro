import csv
import random
from datetime import datetime, timedelta

# Configuración
random.seed(42)  # Para reproducibilidad
NUM_REGISTROS = 200
NOMBRE_ARCHIVO = "ventas_quiosco.csv"

# Datos base
vendedores = ["Maria Gonzalez", "Carlos Rodriguez", "Juan Perez"]
productos = {
    "Coca-Cola 500ml": {"categoria": "Bebidas", "precio": 1200},
    "Pepsi 500ml": {"categoria": "Bebidas", "precio": 1100},
    "Sprite 500ml": {"categoria": "Bebidas", "precio": 1100},
    "Agua Mineral 500ml": {"categoria": "Bebidas", "precio": 600},
    "Papas Lays 90g": {"categoria": "Snacks", "precio": 800},
    "Papas Pringles 100g": {"categoria": "Snacks", "precio": 1200},
    "Maní Japonés 80g": {"categoria": "Snacks", "precio": 700},
    "Alfajor Guaymaren": {"categoria": "Galletitas", "precio": 450},
    "Alfajor Jorgito": {"categoria": "Galletitas", "precio": 500},
    "Galletitas Oreo": {"categoria": "Galletitas", "precio": 900},
    "Chicles Beldent": {"categoria": "Golosinas", "precio": 300},
    "Caramelos Arcor": {"categoria": "Golosinas", "precio": 200},
    "Snickers 50g": {"categoria": "Golosinas", "precio": 500},
    "KitKat 45g": {"categoria": "Golosinas", "precio": 500},
    "Cigarrillos Marlboro": {"categoria": "Tabaco", "precio": 2500},
    "Cigarrillos Philip Morris": {"categoria": "Tabaco", "precio": 2400},
    "Revista Barcelona": {"categoria": "Revistas", "precio": 1500},
    "Diario Clarín": {"categoria": "Diarios", "precio": 600},
    "Barra Cereal": {"categoria": "Golosinas", "precio": 400},
    "Chocolate Águila": {"categoria": "Golosinas", "precio": 700}
}
metodos_pago = ["Efectivo", "Tarjeta", "Transferencia"]

# Generar fechas (enero a marzo 2024)
fecha_inicio = datetime(2024, 1, 1)
fecha_fin = datetime(2024, 3, 31)

# Generar datos
datos = []
for i in range(1, NUM_REGISTROS + 1):
    # Fecha aleatoria dentro del rango
    dias_diff = (fecha_fin - fecha_inicio).days
    dias_aleatorios = random.randint(0, dias_diff)
    fecha = fecha_inicio + timedelta(days=dias_aleatorios)
    
    # Hora aleatoria entre 8:00 y 20:00
    hora = f"{random.randint(8, 19):02d}:{random.randint(0, 59):02d}"
    
    # Seleccionar producto aleatorio
    producto_nombre = random.choice(list(productos.keys()))
    producto_info = productos[producto_nombre]
    
    # Generar cantidad (mayor probabilidad de cantidades bajas)
    cantidad = random.choices([1, 2, 3, 4, 5], weights=[0.5, 0.25, 0.15, 0.07, 0.03])[0]
    
    # Calcular total
    total_venta = cantidad * producto_info["precio"]
    
    # Crear registro
    registro = {
        "id_venta": i,
        "fecha": fecha.strftime("%Y-%m-%d"),
        "vendedor": random.choice(vendedores),
        "producto": producto_nombre,
        "categoria": producto_info["categoria"],
        "cantidad": cantidad,
        "precio_unitario": producto_info["precio"],
        "total_venta": total_venta,
        "hora": hora,
        "metodo_pago": random.choice(metodos_pago)
    }
    
    datos.append(registro)

# Escribir archivo CSV
with open(NOMBRE_ARCHIVO, 'w', newline='', encoding='utf-8') as archivo:
    campos = ["id_venta", "fecha", "vendedor", "producto", "categoria", 
             "cantidad", "precio_unitario", "total_venta", "hora", "metodo_pago"]
    
    writer = csv.DictWriter(archivo, fieldnames=campos)
    writer.writeheader()
    writer.writerows(datos)

print(f"Dataset generado: {NOMBRE_ARCHIVO} con {NUM_REGISTROS} registros")
print(f"Período: {fecha_inicio.strftime('%Y-%m-%d')} a {fecha_fin.strftime('%Y-%m-%d')}")
print(f"Vendedores: {', '.join(vendedores)}")
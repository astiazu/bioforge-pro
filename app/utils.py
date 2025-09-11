# app/utils.py
import os
import cloudinary
import cloudinary.uploader

def upload_to_cloudinary(file_path, folder="bioforge"):
    """
    Sube una imagen a Cloudinary.
    :param file_path: Ruta del archivo local
    :param folder: Carpeta en Cloudinary
    :return: URL segura o None
    """
    try:
        response = cloudinary.uploader.upload(
            file_path,
            folder=folder,
            transformation=[
                {'width': 1200, 'height': 800, 'crop': 'limit'},
                {'quality': 'auto:good'}
            ]
        )
        return response['secure_url']
    except Exception as e:
        print(f"❌ Error subiendo a Cloudinary: {str(e)}")
        return None
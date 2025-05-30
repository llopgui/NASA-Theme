#!/usr/bin/env python3
"""
NASA Theme Image Processor
Procesador de imágenes para el proyecto NASA Theme

Autor: NASA Theme Project
Versión: 1.0.0
Licencia: CC BY-NC-SA 4.0

Este script procesa imágenes para generar todos los formatos y tamaños
necesarios para los temas NASA en Windows y Linux.
"""

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image, ImageEnhance, ImageFilter


class NASAImageProcessor:
    """Procesador de imágenes para temas NASA"""

    # Configuración de tamaños para diferentes tipos de imágenes
    WALLPAPER_SIZES = [
        (1366, 768),  # HD básico
        (1600, 900),  # HD+
        (1920, 1080),  # Full HD
        (2560, 1440),  # 2K/QHD
        (3840, 2160),  # 4K/UHD
        (2560, 1600),  # WQXGA ultrawide
    ]

    ICON_SIZES = [
        (16, 16),  # Iconos muy pequeños
        (22, 22),  # Linux pequeños
        (24, 24),  # Iconos pequeños
        (32, 32),  # Iconos estándar
        (48, 48),  # Iconos medianos
        (64, 64),  # Iconos grandes
        (96, 96),  # Alta resolución
        (128, 128),  # Muy alta resolución
        (256, 256),  # Miniatura máxima
    ]

    TEXTURE_SIZES = [
        (256, 256),  # Texturas pequeñas
        (512, 512),  # Texturas medianas
        (1024, 1024),  # Texturas grandes
    ]

    def __init__(self, output_dir: str = "processed_images"):
        """
        Inicializa el procesador de imágenes

        Args:
            output_dir: Directorio de salida para las imágenes procesadas
        """
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)

        # Crear subdirectorios
        self.wallpapers_dir = self.output_dir / "wallpapers"
        self.icons_dir = self.output_dir / "icons"
        self.textures_dir = self.output_dir / "textures"

        for dir_path in [self.wallpapers_dir, self.icons_dir, self.textures_dir]:
            dir_path.mkdir(exist_ok=True)

    def log(self, message: str, level: str = "INFO") -> None:
        """Registra mensajes con formato"""
        print(f"[{level}] {message}")

    def is_image_file(self, file_path: Path) -> bool:
        """Verifica si un archivo es una imagen soportada"""
        image_extensions = {".jpg", ".jpeg", ".png", ".bmp", ".tiff", ".webp"}
        return file_path.suffix.lower() in image_extensions

    def optimize_image_quality(
        self, image: Image.Image, image_type: str
    ) -> Image.Image:
        """
        Optimiza la calidad de la imagen según su tipo

        Args:
            image: Imagen PIL a optimizar
            image_type: Tipo de imagen ('wallpaper', 'icon', 'texture')

        Returns:
            Imagen optimizada
        """
        # Convertir a RGB si es necesario (para JPG)
        if image.mode in ("RGBA", "LA", "P"):
            if image_type == "wallpaper":
                # Para wallpapers, crear fondo blanco para temas claros
                background = Image.new("RGB", image.size, (255, 255, 255))
                if image.mode == "P":
                    image = image.convert("RGBA")
                background.paste(
                    image, mask=image.split()[-1] if len(image.split()) == 4 else None
                )
                image = background
            elif image_type == "icon":
                # Para iconos, mantener transparencia
                pass  # Mantener RGBA para iconos
            else:
                image = image.convert("RGB")

        # Aplicar filtros de mejora según el tipo
        if image_type == "wallpaper":
            # Mejorar wallpapers ligeramente
            enhancer = ImageEnhance.Sharpness(image)
            image = enhancer.enhance(1.1)

            enhancer = ImageEnhance.Color(image)
            image = enhancer.enhance(1.05)

        return image

    def resize_image(
        self,
        image: Image.Image,
        target_size: Tuple[int, int],
        maintain_aspect: bool = True,
    ) -> Image.Image:
        """
        Redimensiona una imagen manteniendo la relación de aspecto

        Args:
            image: Imagen PIL a redimensionar
            target_size: Tamaño objetivo (ancho, alto)
            maintain_aspect: Si mantener la relación de aspecto

        Returns:
            Imagen redimensionada
        """
        if maintain_aspect:
            # Calcular el tamaño manteniendo proporción
            image.thumbnail(target_size, Image.Resampling.LANCZOS)

            # Si necesitamos un tamaño exacto, crear canvas y centrar
            if image.size != target_size:
                canvas = Image.new(
                    "RGBA" if image.mode == "RGBA" else "RGB",
                    target_size,
                    (0, 0, 0, 0) if image.mode == "RGBA" else (0, 0, 0),
                )

                # Centrar la imagen
                x = (target_size[0] - image.size[0]) // 2
                y = (target_size[1] - image.size[1]) // 2
                canvas.paste(image, (x, y))
                return canvas
        else:
            # Redimensionar sin mantener proporción
            image = image.resize(target_size, Image.Resampling.LANCZOS)

        return image

    def save_optimized_image(
        self, image: Image.Image, output_path: Path, image_type: str, quality: int = 92
    ) -> None:
        """
        Guarda una imagen optimizada

        Args:
            image: Imagen PIL a guardar
            output_path: Ruta de salida
            image_type: Tipo de imagen para optimización
            quality: Calidad para imágenes JPG (1-100)
        """
        # Crear directorio si no existe
        output_path.parent.mkdir(parents=True, exist_ok=True)

        # Determinar formato de salida
        if output_path.suffix.lower() in [".jpg", ".jpeg"]:
            # Guardar como JPG
            if image.mode == "RGBA":
                # Convertir RGBA a RGB con fondo blanco
                background = Image.new("RGB", image.size, (255, 255, 255))
                background.paste(image, mask=image.split()[-1])
                image = background

            image.save(
                output_path, "JPEG", quality=quality, optimize=True, progressive=True
            )

        elif output_path.suffix.lower() == ".png":
            # Guardar como PNG
            if image_type == "icon":
                # PNG optimizado para iconos
                image.save(output_path, "PNG", optimize=True)
            else:
                # PNG con compresión
                image.save(output_path, "PNG", optimize=True, compress_level=6)

        else:
            # Formato automático basado en el contenido
            if image.mode == "RGBA":
                image.save(output_path.with_suffix(".png"), "PNG", optimize=True)
            else:
                image.save(
                    output_path.with_suffix(".jpg"),
                    "JPEG",
                    quality=quality,
                    optimize=True,
                )

    def process_wallpaper(
        self, image_path: Path, theme_type: str = "auto"
    ) -> List[Path]:
        """
        Procesa una imagen como wallpaper

        Args:
            image_path: Ruta de la imagen original
            theme_type: Tipo de tema ('light', 'dark', 'auto')

        Returns:
            Lista de rutas de archivos generados
        """
        self.log(f"Procesando wallpaper: {image_path.name}")

        generated_files = []

        try:
            with Image.open(image_path) as img:
                # Detectar tema automáticamente si es necesario
                if theme_type == "auto":
                    # Calcular brillo promedio para determinar si es claro u oscuro
                    grayscale = img.convert("L")
                    avg_brightness = sum(grayscale.getdata()) / len(grayscale.getdata())
                    theme_type = "light" if avg_brightness > 128 else "dark"
                    self.log(f"Tema detectado automáticamente: {theme_type}")

                # Optimizar imagen
                img = self.optimize_image_quality(img, "wallpaper")

                # Generar diferentes tamaños
                for width, height in self.WALLPAPER_SIZES:
                    # Crear nombre de archivo
                    base_name = f"nasa_{theme_type}_{width}x{height}"

                    # Redimensionar imagen
                    resized_img = self.resize_image(
                        img, (width, height), maintain_aspect=True
                    )

                    # Guardar en diferentes calidades
                    qualities = [92, 85] if width >= 2560 else [92]

                    for quality in qualities:
                        quality_suffix = f"_q{quality}" if len(qualities) > 1 else ""
                        output_path = (
                            self.wallpapers_dir / f"{base_name}{quality_suffix}.jpg"
                        )

                        self.save_optimized_image(
                            resized_img, output_path, "wallpaper", quality
                        )
                        generated_files.append(output_path)

                        # Mostrar información del archivo
                        file_size = output_path.stat().st_size / (1024 * 1024)  # MB
                        self.log(f"  ✓ {output_path.name} ({file_size:.1f} MB)")

        except Exception as e:
            self.log(f"Error procesando wallpaper {image_path}: {e}", "ERROR")

        return generated_files

    def process_icon(self, image_path: Path, icon_name: str = None) -> List[Path]:
        """
        Procesa una imagen como icono

        Args:
            image_path: Ruta de la imagen original
            icon_name: Nombre base para el icono (opcional)

        Returns:
            Lista de rutas de archivos generados
        """
        if not icon_name:
            icon_name = image_path.stem

        self.log(f"Procesando icono: {icon_name}")

        generated_files = []

        try:
            with Image.open(image_path) as img:
                # Optimizar imagen para iconos
                img = self.optimize_image_quality(img, "icon")

                # Generar diferentes tamaños
                for width, height in self.ICON_SIZES:
                    # Crear directorio por tamaño
                    size_dir = self.icons_dir / f"{width}x{height}"
                    size_dir.mkdir(exist_ok=True)

                    # Redimensionar imagen
                    resized_img = self.resize_image(
                        img, (width, height), maintain_aspect=True
                    )

                    # Guardar como PNG (mantiene transparencia)
                    output_path = size_dir / f"{icon_name}.png"
                    self.save_optimized_image(resized_img, output_path, "icon")
                    generated_files.append(output_path)

                    # Mostrar información
                    file_size = output_path.stat().st_size / 1024  # KB
                    self.log(
                        f"  ✓ {width}x{height}: {icon_name}.png ({file_size:.1f} KB)"
                    )

        except Exception as e:
            self.log(f"Error procesando icono {image_path}: {e}", "ERROR")

        return generated_files

    def process_texture(self, image_path: Path, texture_name: str = None) -> List[Path]:
        """
        Procesa una imagen como textura

        Args:
            image_path: Ruta de la imagen original
            texture_name: Nombre base para la textura (opcional)

        Returns:
            Lista de rutas de archivos generados
        """
        if not texture_name:
            texture_name = image_path.stem

        self.log(f"Procesando textura: {texture_name}")

        generated_files = []

        try:
            with Image.open(image_path) as img:
                # Optimizar imagen
                img = self.optimize_image_quality(img, "texture")

                # Generar diferentes tamaños
                for width, height in self.TEXTURE_SIZES:
                    # Redimensionar imagen
                    resized_img = self.resize_image(
                        img, (width, height), maintain_aspect=False
                    )

                    # Guardar como PNG para mantener calidad
                    output_path = (
                        self.textures_dir / f"{texture_name}_{width}x{height}.png"
                    )
                    self.save_optimized_image(resized_img, output_path, "texture")
                    generated_files.append(output_path)

                    # Mostrar información
                    file_size = output_path.stat().st_size / 1024  # KB
                    self.log(
                        f"  ✓ {width}x{height}: {texture_name}_{width}x{height}.png ({file_size:.1f} KB)"
                    )

        except Exception as e:
            self.log(f"Error procesando textura {image_path}: {e}", "ERROR")

        return generated_files

    def process_single_image(
        self,
        image_path: Path,
        process_type: str = "auto",
        theme_type: str = "auto",
        custom_name: str = None,
    ) -> List[Path]:
        """
        Procesa una sola imagen

        Args:
            image_path: Ruta de la imagen
            process_type: Tipo de procesamiento ('wallpaper', 'icon', 'texture', 'auto')
            theme_type: Tipo de tema para wallpapers ('light', 'dark', 'auto')
            custom_name: Nombre personalizado para el archivo

        Returns:
            Lista de archivos generados
        """
        if not self.is_image_file(image_path):
            self.log(f"Archivo no es una imagen válida: {image_path}", "WARNING")
            return []

        # Detectar tipo automáticamente si es necesario
        if process_type == "auto":
            with Image.open(image_path) as img:
                width, height = img.size

                if width >= 1024 and height >= 768:
                    process_type = "wallpaper"
                elif width <= 256 and height <= 256:
                    process_type = "icon"
                else:
                    process_type = "texture"

            self.log(f"Tipo detectado automáticamente: {process_type}")

        # Procesar según el tipo
        if process_type == "wallpaper":
            return self.process_wallpaper(image_path, theme_type)
        elif process_type == "icon":
            return self.process_icon(image_path, custom_name)
        elif process_type == "texture":
            return self.process_texture(image_path, custom_name)
        else:
            self.log(f"Tipo de procesamiento desconocido: {process_type}", "ERROR")
            return []

    def process_directory(
        self,
        directory_path: Path,
        process_type: str = "auto",
        theme_type: str = "auto",
        recursive: bool = True,
    ) -> Dict[str, List[Path]]:
        """
        Procesa todas las imágenes en un directorio

        Args:
            directory_path: Ruta del directorio
            process_type: Tipo de procesamiento
            theme_type: Tipo de tema
            recursive: Si procesar subdirectorios

        Returns:
            Diccionario con archivos generados por imagen
        """
        self.log(f"Procesando directorio: {directory_path}")

        results = {}

        # Buscar archivos de imagen
        pattern = "**/*" if recursive else "*"

        for file_path in directory_path.glob(pattern):
            if file_path.is_file() and self.is_image_file(file_path):
                self.log(f"\n--- Procesando: {file_path.name} ---")
                generated_files = self.process_single_image(
                    file_path, process_type, theme_type
                )
                results[str(file_path)] = generated_files

        return results

    def generate_report(self, results: Dict[str, List[Path]]) -> None:
        """Genera un reporte de los archivos procesados"""
        total_files = sum(len(files) for files in results.values())
        total_size = 0

        for files in results.values():
            for file_path in files:
                if file_path.exists():
                    total_size += file_path.stat().st_size

        total_size_mb = total_size / (1024 * 1024)

        self.log("\n" + "=" * 50)
        self.log("REPORTE DE PROCESAMIENTO")
        self.log("=" * 50)
        self.log(f"Imágenes originales procesadas: {len(results)}")
        self.log(f"Archivos totales generados: {total_files}")
        self.log(f"Tamaño total: {total_size_mb:.1f} MB")
        self.log(f"Directorio de salida: {self.output_dir.absolute()}")

        # Guardar reporte en JSON
        report_path = self.output_dir / "processing_report.json"
        report_data = {
            "total_original_images": len(results),
            "total_generated_files": total_files,
            "total_size_bytes": total_size,
            "total_size_mb": round(total_size_mb, 1),
            "output_directory": str(self.output_dir.absolute()),
            "results": {k: [str(f) for f in v] for k, v in results.items()},
        }

        with open(report_path, "w", encoding="utf-8") as f:
            json.dump(report_data, f, indent=2, ensure_ascii=False)

        self.log(f"Reporte guardado en: {report_path}")


def main():
    """Función principal del script"""
    parser = argparse.ArgumentParser(
        description="Procesador de imágenes para NASA Theme",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Ejemplos de uso:
  python image_processor.py wallpaper.jpg
  python image_processor.py ./images/ --type wallpaper --theme dark
  python image_processor.py icon.png --type icon --name custom_icon
  python image_processor.py ./textures/ --recursive --output ./processed/
        """,
    )

    parser.add_argument("input_path", help="Ruta de imagen o directorio a procesar")
    parser.add_argument(
        "--type",
        "-t",
        choices=["auto", "wallpaper", "icon", "texture"],
        default="auto",
        help="Tipo de procesamiento (default: auto)",
    )
    parser.add_argument(
        "--theme",
        choices=["auto", "light", "dark"],
        default="auto",
        help="Tipo de tema para wallpapers (default: auto)",
    )
    parser.add_argument(
        "--output",
        "-o",
        default="processed_images",
        help="Directorio de salida (default: processed_images)",
    )
    parser.add_argument("--name", "-n", help="Nombre personalizado para el archivo")
    parser.add_argument(
        "--recursive",
        "-r",
        action="store_true",
        help="Procesar subdirectorios recursivamente",
    )
    parser.add_argument(
        "--quiet", "-q", action="store_true", help="Modo silencioso (menos output)"
    )

    args = parser.parse_args()

    # Validar ruta de entrada
    input_path = Path(args.input_path)
    if not input_path.exists():
        print(f"Error: La ruta '{input_path}' no existe.")
        return 1

    # Crear procesador
    processor = NASAImageProcessor(args.output)

    # Suprimir logs si está en modo silencioso
    if args.quiet:
        processor.log = lambda msg, level="INFO": None

    try:
        # Procesar según el tipo de entrada
        if input_path.is_file():
            results = {
                str(input_path): processor.process_single_image(
                    input_path, args.type, args.theme, args.name
                )
            }
        else:
            results = processor.process_directory(
                input_path, args.type, args.theme, args.recursive
            )

        # Generar reporte
        if not args.quiet:
            processor.generate_report(results)

        return 0

    except KeyboardInterrupt:
        processor.log("\nProcesamiento interrumpido por el usuario.", "WARNING")
        return 1
    except Exception as e:
        processor.log(f"Error inesperado: {e}", "ERROR")
        return 1


if __name__ == "__main__":
    sys.exit(main())

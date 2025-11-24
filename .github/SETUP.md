# Configuración del Entorno

Herramientas necesarias para trabajar en el proyecto.

## Instalación

### 1. Compilador C (gcc)
- **Descargar**: https://github.com/niXman/mingw-builds-binaries/releases
- **Versión**: gcc 13.2.0 o superior
- Extraer a `C:\mingw64\` y agregar `C:\mingw64\bin` al PATH

### 2. Python
- **Descargar**: https://www.python.org/downloads/
- **Versión**: Python 3.11 o superior
- Marcar "Add Python to PATH" al instalar

### 3. MARS (simulador MIPS)
- **Descargar**: http://courses.missouristate.edu/kenvollmar/mars/
- **Archivo**: `Mars4_5.jar`
- Requiere Java 8+: https://www.java.com/download/

## Verificar instalación

```powershell
gcc --version
python --version
java -version
```

## Compilar y ejecutar

**C**:
```powershell
gcc -std=c11 -O2 -Wall -Wextra -Wpedantic -Werror -o program.exe main.c
.\program.exe
```

**Python**:
```powershell
python main.py
```

**MIPS**:
```powershell
java -jar Mars4_5.jar
# Luego: File → Open → program.asm → F3 (ensamblar) → F5 (ejecutar)
```

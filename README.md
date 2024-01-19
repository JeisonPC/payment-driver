# Payment Driver

El proyecto Payment Driver es una aplicación web diseñada para facilitar la gestión de transacciones financieras entre conductores y pasajeros. La aplicación permite a los conductores calcular el monto total a pagar por un viaje, así como a los usuarios agregar métodos de pago de forma segura.

# Características Principales
Cálculo de Monto Total: Los conductores pueden ingresar información sobre un viaje, como la distancia recorrida y el tiempo transcurrido, para obtener el monto total a pagar.

Gestión de Métodos de Pago: Los usuarios pueden añadir y gestionar sus métodos de pago de manera segura, utilizando la tokenización de tarjetas para garantizar la privacidad de la información.

Integración con Wompi: La aplicación se integra con la plataforma de pagos Wompi para tokenizar tarjetas y realizar transacciones de forma segura.

## Tabla de Contenidos

- [Instalación](#instalación)
- [Configuración](#configuración)
- [Uso](#uso)
- [Pruebas](#pruebas)

## Instalación

Asegúrate de tener Ruby y Bundler instalados en tu sistema. Luego, sigue estos pasos:

# Clona el repositorio
git clone https://github.com/tu_usuario/tu_proyecto.git

# Entra al directorio del proyecto
cd tu_proyecto

# Instala las dependencias
bundle install

## Configuración
# Configura la Base de Datos:
Ingresa a config/database.rb
Encontrarás la conexión a la DB que tendrás editar:
DB = Sequel.connect(adapter: '@your-db', host: '@your-host',
database: '@database-name', username: '@username', password: '@password')

# Realizar las migraciones:

sequel -m migrations <protocolo>://<usuario>:<contraseña>@<host>/<base_de_datos>

# Configura las Variables de Entorno:

Crea un archivo .env en la raíz del proyecto y define las variables de entorno necesarias. Puedes utilizar el archivo .env.example como referencia.

# Ejemplo de .env

PUBLIC_KEY=your_wompi_public_key
PRIVATE_KEY=your_wompi_private_key
INTEGRITY_KEY=your_wompi_integrity_key

# Inicia la Aplicación:

rackup

# ejecutar pruebas
bundle exec rspec

# MadRunCS

Videojuego 2D de plataformas desarrollado con **Godot Engine**.

Este repositorio contiene el proyecto principal del juego, incluyendo escenas, scripts, recursos, niveles y documentación utilizada por el equipo durante el desarrollo.

El proyecto utiliza una metodología de diseño basada en **grayboxing**, donde primero se valida el gameplay de cada nivel y posteriormente se realiza el Art Pass correspondiente a su ambientación.

---

## Tecnologías

- Godot Engine 4.x
- GDScript
- Git
- GitHub

---

## Abrir el proyecto

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
```

### 2. Entrar a la carpeta

```bash
cd <NOMBRE_DEL_REPOSITORIO>
```

### 3. Abrir Godot

Desde Godot:

1. Seleccionar **Import**.
2. Buscar el archivo:

```text
project.godot
```

3. Importar el proyecto.
4. Abrirlo desde el Project Manager.

Godot generará automáticamente los archivos internos necesarios dentro de `.godot/`.

---

## Estructura general

El proyecto se organiza aproximadamente de la siguiente manera:

```text
res://
│
├── assets/
│   ├── characters/
│   ├── tilesets/
│   ├── environments/
│   ├── ui/
│   ├── audio/
│   └── effects/
│
├── docs/
│   └── CONVENCIONES.md
│
├── resources/
│   └── tilesets/
│
├── scenes/
│   ├── characters/
│   ├── levels/
│   ├── enemies/
│   ├── pickups/
│   ├── gameplay/
│   └── ui/
│
├── scripts/
│   ├── autoload/
│   ├── characters/
│   ├── levels/
│   ├── enemies/
│   ├── pickups/
│   └── ui/
│
├── .gitignore
├── README.md
└── project.godot
```

### `assets/`

Contiene los archivos fuente utilizados por el juego.

Ejemplos:

- Sprites.
- TileSheets.
- Fondos.
- UI.
- Audio.
- Efectos visuales.

### `resources/`

Contiene recursos reutilizables de Godot.

Ejemplo:

```text
resources/tilesets/dev_tileset.tres
```

### `scenes/`

Contiene las escenas `.tscn`.

Ejemplos:

```text
scenes/characters/player.tscn
scenes/levels/level_01.tscn
scenes/levels/level_template.tscn
```

### `scripts/`

Contiene la lógica escrita en GDScript.

Ejemplos:

```text
scripts/characters/player.gd
scripts/levels/level_base.gd
scripts/autoload/scene_loader.gd
scripts/autoload/game_manager.gd
```

### `docs/`

Contiene la documentación del proyecto y las reglas de trabajo del equipo.

---

# Desarrollo de niveles

Todos los niveles deben crearse a partir de:

```text
res://scenes/levels/level_template.tscn
```

No se debe crear manualmente un nivel desde una escena vacía.

Para crear un nuevo nivel:

1. Duplicar `level_template.tscn`.
2. Renombrar la copia.
3. Mantener la estructura base.
4. Construir el graybox.
5. Realizar Playtesting.
6. Ajustar el gameplay.
7. Aprobar el diseño.
8. Realizar el Art Pass.
9. Realizar un Playtest final.

Ejemplo:

```text
level_template.tscn
        ↓
level_05.tscn
```

---

# Estructura estándar de un nivel

Todos los niveles mantienen la siguiente estructura:

```text
Level
│
├── TileMaps
│   ├── Terrain
│   ├── OneWayPlatforms
│   └── Markers
│
├── Gameplay
│   ├── PlayerSpawn
│   ├── Entities
│   ├── Pickups
│   └── LevelExit
│       └── CollisionShape2D
│
├── CameraLimits
│   ├── TopLeft
│   └── BottomRight
│
└── Debug
```

El nodo raíz utiliza:

```text
scripts/levels/level_base.gd
```

`LevelBase` se encarga de funcionalidades comunes como:

- Instanciar al Player.
- Posicionarlo en `PlayerSpawn`.
- Configurar los límites de cámara.
- Detectar el final del nivel.
- Solicitar la transición al siguiente nivel.

---

# Dev TileSet

Durante la primera etapa de diseño de un nivel se utiliza:

```text
res://resources/tilesets/dev_tileset.tres
```

La textura se encuentra en:

```text
res://assets/tilesets/dev/dev_tiles.png
```

El tamaño base de los tiles es:

```text
32 × 32 px
```

El Dev TileSet permite construir niveles rápidamente sin depender del arte final.

Actualmente los tiles tienen el siguiente significado:

```text
Gris     → Terreno sólido
Azul     → Plataforma One-Way
Verde    → Referencia visual de PlayerSpawn
Morado   → Referencia visual de LevelExit
Amarillo → Reservado para referencias futuras
Rojo     → Sin uso oficial actualmente
```

Los tiles de Spawn y Exit son únicamente referencias visuales.

La lógica real se encuentra en:

```text
Gameplay/PlayerSpawn
Gameplay/LevelExit
```

---

# Grayboxing

Todo nivel comienza como un graybox.

Durante esta etapa se valida principalmente:

- Movimiento.
- Saltos.
- Distancias.
- Plataformas.
- Alturas.
- Recorrido.
- Ritmo.
- Dificultad.
- Spawn.
- Exit.
- CameraLimits.

El aspecto visual final no es prioritario durante esta etapa.

El objetivo es comprobar primero que el nivel sea divertido y funcional.

---

# Art Pass

El Art Pass comienza únicamente después de aprobar el graybox.

Durante esta etapa el nivel recibe su ambientación visual definitiva.

Los TileSets artísticos se organizan por ambientación y pueden reutilizarse entre diferentes niveles.

Ejemplos:

```text
forest_tileset.tres
city_tileset.tres
lab_tileset.tres
```

No es necesario crear un TileSet diferente para cada nivel.

El flujo general es:

```text
Level Template
      ↓
Graybox
      ↓
Playtest
      ↓
Ajustes
      ↓
Gameplay aprobado
      ↓
Art Pass
      ↓
Playtest final
      ↓
Nivel terminado
```

> **Primero se valida el gameplay. Después se aplica el arte.**

---

# Collision Layers

Actualmente el proyecto utiliza la siguiente convención:

```text
Layer 1 → World
Layer 2 → Player
Layer 3 → Enemies
Layer 4 → Pickups
Layer 5 → Hazards
Layer 6 → Level Triggers
```

Ejemplo actual del Player:

```text
Layer:
2

Mask:
1, 3, 5
```

Ejemplo actual del LevelExit:

```text
Layer:
6

Mask:
2
```

Las Collision Layers no deben modificarse arbitrariamente.

Cualquier nueva capa debe documentarse antes de convertirse en parte del estándar del proyecto.

---

# Trabajo colaborativo

El proyecto utiliza Git y GitHub para control de versiones.

La rama principal es:

```text
main
```

`main` debe mantenerse funcional.

Para trabajar en funcionalidades independientes se recomienda utilizar ramas.

Ejemplos:

```text
feature/level-02
feature/forest-tileset
feature/enemy-system

fix/player-camera
fix/level-exit

docs/level-design

refactor/level-structure
```

---

# Commits

Los commits deben ser pequeños, claros y relacionados con un objetivo específico.

Formato recomendado:

```text
tipo: descripción
```

Ejemplos:

```text
feat: add development tileset
feat: create level template
feat: add player movement

fix: prevent player from sliding
fix: defer level transition

docs: define project conventions

refactor: reorganize level hierarchy

chore: configure repository
```

Tipos recomendados:

```text
feat      Nueva funcionalidad
fix       Corrección de errores
docs      Documentación
refactor  Reorganización sin cambiar comportamiento esperado
chore     Configuración o mantenimiento
style     Cambios de formato
test      Pruebas
```

---

# Recursos compartidos

Algunos archivos afectan directamente a varias partes del proyecto y deben modificarse con especial cuidado:

```text
project.godot
level_template.tscn
dev_tileset.tres
level_base.gd
SceneLoader
GameManager
```

Cuando sea posible, se debe evitar que varias personas modifiquen simultáneamente el mismo `.tscn` o `.tres`.

Especialmente los TileSets pueden producir conflictos de Git difíciles de resolver.

---

# Convenciones completas

Las reglas detalladas del proyecto se encuentran en:

```text
docs/CONVENCIONES.md
```

Antes de realizar cambios estructurales importantes, crear nuevos sistemas o modificar recursos compartidos, se debe revisar este documento.

---

# Estado actual de la base del proyecto

La configuración inicial incluye:

- Movimiento del Player.
- Salto.
- Camera2D.
- CameraLimits por nivel.
- Sistema base de niveles.
- PlayerSpawn.
- LevelExit.
- Transición entre niveles.
- Level Template.
- Dev TileSet de 32 × 32 px.
- Terrain sólido.
- One-Way Platforms.
- Markers visuales para Spawn y Exit.
- Convenciones de Collision Layers.
- SceneLoader.
- GameManager.
- Control de versiones con Git.

Esta infraestructura sirve como base para continuar desarrollando contenido, niveles, arte y sistemas adicionales.

---

# Documentación

Documentación disponible:

```text
README.md
docs/CONVENCIONES.md
```

`README.md` proporciona una introducción general al proyecto.

`CONVENCIONES.md` contiene los estándares técnicos y de colaboración que deben seguir todos los integrantes del equipo.

---

# Regla principal del proyecto

> **Mantener una estructura común, validar primero el gameplay y utilizar Git como fuente oficial del proyecto.**
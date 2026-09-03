# Convenciones del Proyecto

Este documento define los estándares técnicos, de organización y de trabajo colaborativo que deben seguirse durante el desarrollo del proyecto.

El objetivo es mantener una estructura consistente entre escenas, scripts, assets, niveles y contribuciones realizadas por los diferentes miembros del equipo.

Estas convenciones pueden evolucionar conforme avance el proyecto, pero cualquier cambio importante debe quedar reflejado en este documento.

---

# 1. Principios generales

Todo cambio realizado en el proyecto debe priorizar:

- Consistencia.
- Legibilidad.
- Reutilización.
- Separación entre lógica y presentación.
- Facilidad de mantenimiento.
- Evitar duplicación innecesaria.
- Evitar soluciones específicas cuando puedan resolverse mediante sistemas reutilizables.
- Mantener una estructura comprensible para cualquier integrante del equipo.

Antes de crear una nueva estructura, escena, sistema o recurso, se debe comprobar si ya existe uno equivalente dentro del proyecto.

---

# 2. Tecnologías del proyecto

El proyecto utiliza:

- Godot Engine 4.x.
- GDScript.
- Git para control de versiones.

Todos los integrantes deben utilizar la versión de Godot acordada por el equipo para evitar incompatibilidades en archivos `.tscn`, `.tres` y `project.godot`.

---

# 3. Estructura general del proyecto

La estructura general del proyecto seguirá aproximadamente esta organización:

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

No se deben guardar archivos arbitrariamente en la raíz del proyecto.

Cada archivo debe ubicarse en la carpeta que corresponda según su responsabilidad.

---

# 4. Organización de assets

Todos los recursos gráficos, de audio y efectos deben almacenarse dentro de:

```text
res://assets/
```

Ejemplos:

```text
assets/characters/
assets/tilesets/
assets/environments/
assets/ui/
assets/audio/
assets/effects/
```

No deben guardarse assets gráficos dentro de carpetas de scripts.

---

# 5. Organización de escenas

Las escenas `.tscn` se almacenan dentro de:

```text
res://scenes/
```

Ejemplos:

```text
scenes/characters/player.tscn
scenes/levels/level_01.tscn
scenes/ui/main_menu.tscn
```

---

# 6. Organización de scripts

Los scripts `.gd` se almacenan dentro de:

```text
res://scripts/
```

Ejemplos:

```text
scripts/characters/player.gd
scripts/levels/level_base.gd
scripts/autoload/scene_loader.gd
```

La ubicación del script debe reflejar, cuando sea posible, la responsabilidad de la escena o sistema al que pertenece.

---

# 7. Organización de resources

Los recursos reutilizables de Godot, como TileSets, Themes y otros `.tres`, se almacenan dentro de:

```text
res://resources/
```

Ejemplo:

```text
resources/tilesets/dev_tileset.tres
resources/tilesets/forest_tileset.tres
```

Los archivos fuente de arte permanecen separados dentro de:

```text
assets/
```

Ejemplo:

```text
assets/tilesets/dev/dev_tiles.png
resources/tilesets/dev_tileset.tres
```

---

# 8. Convenciones de nombres

## 8.1 Archivos

Los nombres de archivos utilizan `snake_case`.

Correcto:

```text
player.gd
player.tscn
level_base.gd
level_01.tscn
scene_loader.gd
dev_tileset.tres
forest_tiles.png
```

Incorrecto:

```text
Player.gd
Level01.tscn
DevTileSet.tres
SceneLoaderScript.gd
tilesFINAL.png
```

---

## 8.2 Nodos

Los nodos dentro de escenas utilizan `PascalCase`.

Correcto:

```text
Player
PlayerSpawn
LevelExit
CameraLimits
OneWayPlatforms
CollisionShape2D
```

Incorrecto:

```text
player
player_spawn
level_exit
camera_limits
```

---

## 8.3 Clases

Las clases declaradas mediante `class_name` utilizan `PascalCase`.

Ejemplo:

```gdscript
class_name LevelBase
```

---

## 8.4 Variables

Las variables utilizan `snake_case`.

Ejemplo:

```gdscript
var player_speed: float
var current_level: int
var jump_velocity: float
```

---

## 8.5 Funciones

Las funciones utilizan `snake_case`.

Ejemplo:

```gdscript
func load_level() -> void:
	pass
```

---

## 8.6 Constantes

Las constantes utilizan `UPPER_SNAKE_CASE`.

Ejemplo:

```gdscript
const PLAYER_SCENE := preload("res://scenes/characters/player.tscn")
const MAX_HEALTH := 3
```

---

## 8.7 Señales

Las señales utilizan `snake_case` y describen eventos.

Ejemplo:

```gdscript
signal level_completed
signal player_died
signal item_collected
```

---

# 9. Tipado en GDScript

Se recomienda utilizar tipado siempre que el tipo sea conocido.

Preferido:

```gdscript
var player: CharacterBody2D
var speed: float = 200.0

func move_player(delta: float) -> void:
	pass
```

Evitar:

```gdscript
var player
var speed = 200
```

cuando el tipo puede especificarse claramente.

---

# 10. Responsabilidad de los scripts

Cada script debe tener una responsabilidad clara.

Ejemplos:

```text
player.gd
```

Se encarga del comportamiento del jugador.

```text
level_base.gd
```

Se encarga del comportamiento común de todos los niveles.

```text
scene_loader.gd
```

Se encarga de la carga y transición entre escenas.

Se deben evitar scripts excesivamente grandes que administren múltiples sistemas no relacionados.

---

# 11. Funciones internas

Las funciones internas utilizan el prefijo `_`.

Ejemplo:

```gdscript
func _apply_limits() -> void:
	pass

func _on_exit_body_entered(body: Node2D) -> void:
	pass
```

---

# 12. Callbacks de señales

Los callbacks de señales siguen preferiblemente el patrón:

```text
_on_<nodo>_<senal>
```

Ejemplo:

```gdscript
func _on_exit_body_entered(body: Node2D) -> void:
	pass
```

---

# 13. Autoloads

Los Autoloads deben utilizarse únicamente para sistemas que realmente necesitan existir globalmente durante todo el juego.

Actualmente existen sistemas como:

```text
GameManager
SceneLoader
```

No se debe crear un Autoload para resolver problemas que puedan gestionarse localmente dentro de una escena.

---

# 14. Diseño de niveles

Todos los niveles deben crearse a partir de:

```text
res://scenes/levels/level_template.tscn
```

No se debe crear manualmente la estructura de un nivel desde una escena vacía.

Para crear un nivel nuevo:

1. Duplicar `level_template.tscn`.
2. Renombrar la copia.
3. Mantener la estructura base.
4. Construir el nuevo nivel dentro de esa copia.

Ejemplo:

```text
level_template.tscn
        ↓
level_05.tscn
```

---

# 15. Nombres de niveles

Los niveles utilizan el formato:

```text
level_01.tscn
level_02.tscn
level_03.tscn
level_04.tscn
```

Se mantiene el formato con dos dígitos.

Correcto:

```text
level_01.tscn
level_09.tscn
level_12.tscn
```

Incorrecto:

```text
level1.tscn
Level02.tscn
nivel_3.tscn
```

---

# 16. Estructura obligatoria de un nivel

Todos los niveles deben mantener la siguiente jerarquía:

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

Tipos esperados:

```text
Level                 Node2D

TileMaps              Node2D
Terrain               TileMapLayer
OneWayPlatforms       TileMapLayer
Markers               TileMapLayer

Gameplay              Node2D
PlayerSpawn            Marker2D
Entities               Node2D
Pickups                Node2D
LevelExit              Area2D
CollisionShape2D       CollisionShape2D

CameraLimits           Node2D
TopLeft                Marker2D
BottomRight            Marker2D

Debug                  Node2D
```

---

# 17. LevelBase

El nodo raíz `Level` utiliza:

```text
res://scripts/levels/level_base.gd
```

`LevelBase` centraliza el comportamiento común de todos los niveles.

Entre sus responsabilidades se encuentran:

- Instanciar al Player.
- Colocar al Player en `PlayerSpawn`.
- Configurar los límites de la cámara.
- Detectar el `LevelExit`.
- Solicitar el cambio al siguiente nivel.

Los niveles individuales no deben volver a implementar estas funciones.

---

# 18. Rutas obligatorias del nivel

`LevelBase` depende de rutas específicas como:

```gdscript
$Gameplay/PlayerSpawn
$Gameplay/Entities
$Gameplay/LevelExit
$CameraLimits/TopLeft
$CameraLimits/BottomRight
```

Estas rutas forman parte del contrato de todos los niveles.

No deben renombrarse ni moverse arbitrariamente.

Cambiar esta jerarquía puede romper todos los niveles que utilizan `LevelBase`.

---

# 19. PlayerSpawn

El punto real donde aparece el jugador se encuentra en:

```text
Gameplay/PlayerSpawn
```

y debe ser un:

```text
Marker2D
```

`LevelBase` utiliza este nodo para posicionar al Player al iniciar el nivel.

---

# 20. Marcador visual de Spawn

Durante el grayboxing se utiliza el tile verde del Dev TileSet para indicar visualmente la posición del Spawn.

El tile verde:

- No tiene lógica.
- No tiene colisión.
- No instancia al Player.
- Es solamente una referencia visual.

Debe colocarse aproximadamente en la misma posición que:

```text
Gameplay/PlayerSpawn
```

La posición real siempre está determinada por el `Marker2D`.

---

# 21. LevelExit

La salida real del nivel se encuentra en:

```text
Gameplay/LevelExit
```

Debe ser:

```text
Area2D
└── CollisionShape2D
```

El `Area2D` detecta cuando el Player entra en la zona de salida.

---

# 22. Configuración de LevelExit

La configuración actual es:

```text
Collision Layer: 6
Collision Mask: 2
Monitoring: On
```

Esto permite que el `LevelExit` detecte al Player, que pertenece a Collision Layer 2.

---

# 23. Marcador visual de salida

Durante el grayboxing se utiliza el tile morado del Dev TileSet para representar visualmente la salida.

El tile morado:

- No tiene lógica.
- No tiene colisión.
- No cambia de nivel.
- Es únicamente una referencia visual.

Debe colocarse aproximadamente donde se encuentre:

```text
Gameplay/LevelExit
```

---

# 24. Entities

El nodo:

```text
Gameplay/Entities
```

se utiliza como contenedor para entidades dinámicas relacionadas con gameplay.

Ejemplos:

- Player instanciado en runtime.
- Enemigos.
- NPC.
- Plataformas móviles.
- Objetos dinámicos.

No debe utilizarse para decoración estática.

---

# 25. Pickups

El nodo:

```text
Gameplay/Pickups
```

se utiliza como contenedor para elementos recolectables.

Ejemplos:

- Monedas.
- Power-ups.
- Llaves.
- Coleccionables.
- Objetos recolectables.

---

# 26. CameraLimits

Cada nivel contiene:

```text
CameraLimits
├── TopLeft
└── BottomRight
```

Ambos nodos son:

```text
Marker2D
```

`TopLeft` representa el límite superior izquierdo de la cámara.

`BottomRight` representa el límite inferior derecho.

Cada diseñador debe ajustar estos marcadores según las dimensiones de su nivel.

---

# 27. Cámara

La `Camera2D` pertenece al Player.

Los límites de cámara se configuran desde `LevelBase` utilizando:

```text
CameraLimits/TopLeft
CameraLimits/BottomRight
```

No se deben modificar valores específicos de límites directamente dentro del Player para solucionar problemas particulares de un único nivel.

---

# 28. Debug

El nodo:

```text
Debug
```

se utiliza exclusivamente para herramientas y elementos temporales de desarrollo.

Ejemplos:

- Líneas de referencia.
- Visualización de áreas.
- Información temporal.
- Marcadores auxiliares.
- Herramientas de debugging.

No se debe colocar gameplay obligatorio dentro de `Debug`.

---

# 29. Grid estándar

El tamaño base para construir niveles es:

```text
32 × 32 px
```

Por lo tanto:

```text
1 tile = 32 × 32 px
```

Toda geometría jugable debe respetar esta cuadrícula siempre que sea posible.

---

# 30. Escala de TileMapLayer

Los `TileMapLayer` deben mantenerse siempre en:

```text
Scale = (1, 1)
```

No se debe cambiar su escala para aumentar o disminuir el tamaño de los tiles.

Incorrecto:

```text
Scale = (2, 2)
Scale = (0.5, 0.5)
Scale = (1.5, 1.5)
```

Si un elemento necesita ocupar más espacio, debe utilizar varios tiles o un asset diseñado con dimensiones apropiadas.

---

# 31. Dev TileSet

El recurso oficial utilizado para grayboxing es:

```text
res://resources/tilesets/dev_tileset.tres
```

Su textura se encuentra en:

```text
res://assets/tilesets/dev/dev_tiles.png
```

Dimensiones:

```text
128 × 96 px
```

Distribución:

```text
4 columnas × 3 filas
```

Cada tile:

```text
32 × 32 px
```

---

# 32. Objetivo del Dev TileSet

El Dev TileSet se utiliza durante las etapas iniciales de diseño y prueba.

Su objetivo es permitir construir niveles rápidamente sin depender del arte final.

Durante esta etapa el equipo debe concentrarse principalmente en:

- Movimiento.
- Saltos.
- Plataformas.
- Distancias.
- Recorrido.
- Ritmo.
- Dificultad.
- Spawn.
- Exit.
- CameraLimits.
- Gameplay general.

---

# 33. Tiles grises

Los tiles grises representan:

```text
TERRENO SÓLIDO
```

Se utilizan exclusivamente en:

```text
TileMaps/Terrain
```

Poseen colisión completa.

Pueden utilizarse para:

- Suelo.
- Paredes.
- Techos.
- Bloques.
- Plataformas completamente sólidas.

---

# 34. Tiles azules

Los tiles azules representan:

```text
ONE-WAY PLATFORMS
```

Se utilizan exclusivamente en:

```text
TileMaps/OneWayPlatforms
```

El Player debe:

- Poder atravesarlos desde abajo.
- Colisionar con ellos cuando cae desde arriba.
- Poder caminar sobre ellos.

---

# 35. Tile verde

El tile verde representa visualmente:

```text
PLAYER SPAWN
```

Se utiliza dentro de:

```text
TileMaps/Markers
```

No tiene colisión.

No contiene lógica.

Debe acompañar visualmente a:

```text
Gameplay/PlayerSpawn
```

---

# 36. Tile morado

El tile morado representa visualmente:

```text
LEVEL EXIT
```

Se utiliza dentro de:

```text
TileMaps/Markers
```

No tiene colisión.

No contiene lógica.

Debe acompañar visualmente a:

```text
Gameplay/LevelExit
```

---

# 37. Tile amarillo

El tile amarillo queda reservado para futuras referencias de gameplay.

Posibles usos:

- Checkpoints.
- Interacciones.
- Objetivos secundarios.
- Puntos especiales del nivel.

Actualmente no tiene un uso obligatorio.

---

# 38. Tile rojo

El tile rojo no forma parte actualmente del estándar de gameplay.

No se utilizará como hazard mientras no exista un sistema de hazards definido oficialmente.

El hecho de que exista dentro de `dev_tiles.png` no significa que deba utilizarse.

---

# 39. Markers

El nodo:

```text
TileMaps/Markers
```

contiene referencias visuales utilizadas durante el grayboxing.

Los Markers:

- No contienen lógica.
- No sustituyen nodos reales.
- No tienen colisiones.
- Facilitan la lectura del nivel dentro del editor.

---

# 40. Terrain

El nodo:

```text
TileMaps/Terrain
```

contiene exclusivamente terreno completamente sólido.

No colocar aquí:

- One-way platforms.
- Spawn.
- Exit.
- Markers.
- Pickups.
- Enemigos.

---

# 41. OneWayPlatforms

El nodo:

```text
TileMaps/OneWayPlatforms
```

contiene exclusivamente plataformas atravesables desde abajo.

No deben mezclarse con:

```text
TileMaps/Terrain
```

---

# 42. Flujo oficial de diseño de niveles

Todo nivel debe pasar por las siguientes etapas:

```text
Level Template
      ↓
Graybox
      ↓
Playtest
      ↓
Ajustes
      ↓
Aprobación del gameplay
      ↓
Art Pass
      ↓
Playtest final
      ↓
Nivel terminado
```

---

# 43. Grayboxing

Todo nivel comienza utilizando:

```text
dev_tileset.tres
```

Durante esta etapa no se prioriza el aspecto visual.

El objetivo es validar:

- Movimiento.
- Saltos.
- Distancias.
- Plataformas.
- Alturas.
- Recorrido.
- Ritmo.
- Dificultad.
- CameraLimits.
- PlayerSpawn.
- LevelExit.

---

# 44. Playtesting del graybox

Antes de comenzar el arte final se debe comprobar:

- Que el nivel puede completarse.
- Que todos los saltos necesarios son posibles.
- Que el Player no queda atrapado.
- Que las plataformas funcionan correctamente.
- Que la cámara permite ver correctamente el recorrido.
- Que el Spawn está correctamente colocado.
- Que la salida funciona.
- Que el recorrido principal es comprensible.

---

# 45. Art Pass

El Art Pass se realiza únicamente después de aprobar el graybox.

Consiste en reemplazar o vestir la geometría de desarrollo utilizando el estilo visual correspondiente a la ambientación.

Ejemplos:

```text
forest_tileset
city_tileset
lab_tileset
```

---

# 46. TileSets por ambientación

Los TileSets artísticos se organizan por ambientación y no por nivel.

Correcto:

```text
forest_tileset.tres
```

Puede ser reutilizado por:

```text
level_01
level_04
level_07
```

Incorrecto:

```text
level_01_tileset.tres
level_02_tileset.tres
level_03_tileset.tres
```

salvo que exista una razón técnica o artística claramente justificada.

---

# 47. Organización de TileSets

Los assets de los TileSets se organizan aproximadamente así:

```text
assets/
└── tilesets/
    ├── dev/
    ├── forest/
    ├── city/
    └── lab/
```

Los recursos de Godot asociados se almacenan en:

```text
resources/
└── tilesets/
```

Ejemplo:

```text
assets/tilesets/forest/forest_tiles.png
resources/tilesets/forest_tileset.tres
```

---

# 48. Tamaño de assets para TileMaps

El tamaño base es:

```text
32 × 32 px
```

Los assets pueden utilizar dimensiones mayores siempre que sean múltiplos coherentes del grid.

Ejemplos:

```text
32 × 32
64 × 32
32 × 64
64 × 64
96 × 32
```

---

# 49. Art Pass y gameplay

El Art Pass no debe alterar arbitrariamente el gameplay aprobado durante el grayboxing.

El arte puede cambiar la apariencia, pero no debe modificar sin volver a probar:

- Alturas.
- Distancias.
- Longitud de plataformas.
- Posiciones de saltos.
- Rutas.
- Colisiones.

Si el Art Pass requiere cambiar geometría jugable, el nivel debe volver a Playtesting.

---

# 50. Pixel art

Para assets de pixel art:

- No utilizar antialiasing.
- Mantener píxeles definidos.
- Evitar escalado fraccional.
- Mantener coherencia de resolución.
- Respetar el grid definido.
- Mantener coherencia visual entre assets.
- Evitar mezclar estilos incompatibles.
- Mantener una dirección de iluminación consistente cuando corresponda.

---

# 51. Collision Layers

El estándar actual de Collision Layers es:

```text
Layer 1 → World
Layer 2 → Player
Layer 3 → Enemies
Layer 4 → Pickups
Layer 5 → Hazards
Layer 6 → Level Triggers
```

Estas capas no deben modificarse arbitrariamente.

---

# 52. Layer 1 — World

Se utiliza para:

- Terrain.
- Suelo.
- Paredes.
- Plataformas sólidas.
- Elementos físicos del escenario.

---

# 53. Layer 2 — Player

Se utiliza exclusivamente para el Player.

Configuración actual:

```text
Player Layer:
2

Player Mask:
1, 3, 5
```

Esto significa que el Player puede detectar o interactuar físicamente con:

```text
Layer 1 → World
Layer 3 → Enemies
Layer 5 → Hazards
```

---

# 54. Layer 3 — Enemies

Reservada para enemigos.

Su configuración específica podrá evolucionar cuando se termine el sistema correspondiente.

---

# 55. Layer 4 — Pickups

Reservada para objetos recolectables.

Normalmente un Pickup podrá utilizar un `Area2D` cuya máscara detecte:

```text
Layer 2 → Player
```

---

# 56. Layer 5 — Hazards

Reservada para elementos peligrosos.

Su implementación definitiva se realizará cuando exista un sistema de hazards.

Actualmente no es obligatorio utilizar esta capa.

---

# 57. Layer 6 — Level Triggers

Reservada para triggers relacionados con niveles.

Actualmente incluye:

```text
LevelExit
```

Configuración:

```text
LevelExit Layer:
6

LevelExit Mask:
2
```

Esto permite que el `LevelExit` detecte al Player.

---

# 58. Nuevas Collision Layers

No se deben utilizar nuevas capas sin documentar previamente su propósito.

Evitar configuraciones como:

```text
Layer 11
Layer 17
Layer 23
```

sin una razón definida.

Si se necesita una nueva Collision Layer:

1. Se define su propósito.
2. Se comunica al equipo.
3. Se configura en Project Settings.
4. Se actualiza este documento.

---

# 59. Recursos compartidos

Los siguientes recursos afectan a buena parte del proyecto:

```text
project.godot
level_template.tscn
dev_tileset.tres
level_base.gd
GameManager
SceneLoader
```

Deben modificarse con especial cuidado.

---

# 60. Level Template

`level_template.tscn` se considera infraestructura compartida del proyecto.

No debe contener:

- Diseño específico de un nivel.
- Enemigos específicos.
- Pickups específicos.
- Decoraciones específicas.
- Arte exclusivo de una ambientación.

Debe contener únicamente la estructura necesaria para comenzar cualquier nivel.

---

# 61. Modificación del Level Template

Si se modifica:

```text
level_template.tscn
```

debe evaluarse si los niveles existentes también necesitan actualizarse.

Los niveles previamente creados no se actualizan automáticamente cuando cambia el template.

Por esta razón, los cambios estructurales deben realizarse con cuidado.

---

# 62. TileSets compartidos

Recursos como:

```text
dev_tileset.tres
forest_tileset.tres
city_tileset.tres
```

son recursos compartidos.

Siempre que sea posible, se debe evitar que varias personas modifiquen simultáneamente el mismo TileSet.

Los conflictos de Git en archivos `.tres` pueden ser difíciles de resolver.

---

# 63. Fuente oficial de un TileSet

No deben existir múltiples copias innecesarias del mismo recurso.

Incorrecto:

```text
forest_tileset_copy.tres
forest_tileset_persona1.tres
forest_tileset_final.tres
forest_tileset_FINAL2.tres
```

Correcto:

```text
forest_tileset.tres
```

Debe existir una única fuente oficial para cada TileSet.

---

# 64. Archivos temporales

No crear archivos con nombres como:

```text
sprite_final.png
sprite_final2.png
sprite_final_real.png
tiles_final_v2.png
level_test_final2.tscn
```

Git debe utilizarse para conservar versiones anteriores.

Los nombres de archivos deben describir su propósito, no su estado temporal.

---

# 65. Git

Git es el sistema oficial de control de versiones del proyecto.

No se deben compartir versiones completas del proyecto mediante ZIP como método habitual de sincronización.

Los cambios deben integrarse mediante el repositorio.

---

# 66. Rama principal

La rama principal es:

```text
main
```

`main` debe representar una versión funcional del proyecto.

No se deben realizar experimentos grandes directamente sobre `main`.

---

# 67. Ramas de trabajo

Para cambios independientes se recomienda utilizar ramas.

Formato:

```text
feature/<nombre>
fix/<nombre>
docs/<nombre>
refactor/<nombre>
```

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

# 68. Commits

Los commits deben representar cambios pequeños, claros y coherentes.

Formato recomendado:

```text
tipo: descripción
```

Ejemplos:

```text
feat: add development tileset
feat: create base level template
feat: add player movement

fix: prevent player from sliding on terrain
fix: defer level transition

docs: define project conventions

refactor: reorganize level hierarchy

chore: configure repository
```

---

# 69. Tipos de commit

Tipos recomendados:

```text
feat
```

Nueva funcionalidad.

```text
fix
```

Corrección de errores.

```text
docs
```

Cambios de documentación.

```text
refactor
```

Reorganización del código o estructura sin cambiar la funcionalidad esperada.

```text
chore
```

Configuración, mantenimiento o tareas generales.

```text
style
```

Cambios de formato que no afectan funcionalidad.

```text
test
```

Cambios relacionados con pruebas.

---

# 70. Antes de hacer commit

Antes de realizar un commit se debe comprobar:

1. El proyecto abre correctamente.
2. No existen errores nuevos en la consola.
3. Las escenas modificadas funcionan.
4. El Player sigue funcionando si el cambio puede afectarlo.
5. Los niveles afectados pueden ejecutarse.
6. No se agregaron archivos temporales.
7. `.godot/` no está siendo trackeado.
8. El commit contiene cambios relacionados entre sí.

---

# 71. Archivos ignorados por Git

El `.gitignore` debe excluir como mínimo:

```gitignore
.godot/
.mono/
.vscode/
.idea/
.DS_Store
Thumbs.db
*.tmp
*.temp
```

La carpeta:

```text
.godot/
```

no debe subirse al repositorio.

Godot puede regenerarla automáticamente.

---

# 72. Trabajo colaborativo

Antes de modificar recursos compartidos importantes se recomienda comunicarlo al equipo.

Especialmente:

```text
level_template.tscn
dev_tileset.tres
project.godot
autoloads
```

Esto reduce conflictos de Git.

---

# 73. Trabajo simultáneo en niveles

Siempre que sea posible, diferentes integrantes deben trabajar en niveles diferentes.

Ejemplo:

```text
Persona A → level_01
Persona B → level_02
Persona C → level_03
Persona D → level_04
```

Esto reduce conflictos sobre archivos `.tscn`.

---

# 74. Trabajo simultáneo en TileSets

Se debe evitar que dos personas editen simultáneamente el mismo `.tres`.

Cuando se esté construyendo o modificando un TileSet compartido, es recomendable definir temporalmente una persona responsable de ese recurso.

---

# 75. Flujo recomendado para crear un nivel nuevo

1. Actualizar la copia local del repositorio.
2. Duplicar `level_template.tscn`.
3. Renombrarlo como `level_XX.tscn`.
4. Crear una rama de trabajo si corresponde.
5. Construir el graybox.
6. Colocar `PlayerSpawn`.
7. Colocar el marker verde.
8. Configurar `LevelExit`.
9. Colocar el marker morado.
10. Ajustar `CameraLimits`.
11. Probar el recorrido.
12. Corregir problemas.
13. Validar el gameplay.
14. Realizar el Art Pass.
15. Volver a realizar Playtesting.
16. Hacer commit.
17. Integrar los cambios.

---

# 76. Definición de graybox terminado

Un graybox se considera terminado cuando:

- El nivel puede completarse.
- Todos los saltos necesarios funcionan.
- Las plataformas están correctamente configuradas.
- No existen zonas donde el Player quede atrapado accidentalmente.
- PlayerSpawn funciona.
- LevelExit funciona.
- CameraLimits funciona.
- La dificultad inicial es aceptable.
- El recorrido principal es comprensible.

El aspecto visual no es requisito para aprobar esta etapa.

---

# 77. Definición de nivel terminado

Un nivel no se considera terminado únicamente porque tenga arte.

Debe cumplir:

- PlayerSpawn correctamente configurado.
- LevelExit funcional.
- CameraLimits correctos.
- Geometría sin errores.
- Plataformas funcionando.
- Recorrido posible.
- Sin zonas de bloqueo accidental.
- Graybox aprobado.
- Art Pass terminado.
- Playtest posterior al Art Pass.
- Sin errores importantes en consola.

---

# 78. Reglas para el Player

El Player se instancia desde `LevelBase`.

No debe colocarse manualmente una instancia permanente del Player dentro de cada nivel.

La posición inicial se determina utilizando:

```text
Gameplay/PlayerSpawn
```

El Player contiene su propia `Camera2D`.

---

# 79. Movimiento del Player

La lógica de movimiento pertenece exclusivamente al script del Player.

Los niveles no deben modificar directamente:

```gdscript
player.velocity
player.speed
player.jump_velocity
```

para solucionar problemas específicos del diseño de un nivel.

Si un nivel requiere mecánicas especiales, estas deberán implementarse mediante sistemas definidos explícitamente.

---

# 80. Plataformas móviles

Las plataformas móviles, si se agregan posteriormente, deben implementarse mediante escenas independientes.

No deben simularse modificando accidentalmente propiedades como:

```text
Constant Linear Velocity
```

de un `StaticBody2D` utilizado como suelo.

Los cuerpos estáticos utilizados como terreno normal deben permanecer sin velocidad constante.

---

# 81. Separación entre lógica y representación visual

Los elementos visuales del TileMap no sustituyen lógica de gameplay.

Ejemplos:

```text
Tile verde
```

Representación visual del Spawn.

```text
Gameplay/PlayerSpawn
```

Spawn real utilizado por el código.

```text
Tile morado
```

Representación visual del Exit.

```text
Gameplay/LevelExit
```

Salida real utilizada por el código.

Esta separación debe mantenerse para futuros sistemas equivalentes.

---

# 82. Creación de escenas reutilizables

Los elementos que posean comportamiento propio deben crearse preferiblemente como escenas reutilizables.

Ejemplos:

```text
player.tscn
enemy.tscn
pickup.tscn
moving_platform.tscn
checkpoint.tscn
```

No se debe copiar manualmente la misma estructura compleja en múltiples niveles.

---

# 83. Propiedades exportadas

Se deben utilizar variables `@export` cuando sea útil permitir ajustes desde el Inspector.

Ejemplo:

```gdscript
@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
```

No se deben exportar variables internas que no tengan sentido modificar desde el editor.

---

# 84. Valores mágicos

Se debe evitar repetir valores sin contexto dentro del código.

Evitar:

```gdscript
velocity.x = 200
```

cuando existe:

```gdscript
@export var speed: float = 200.0
```

Los valores importantes deben tener nombres que expliquen su propósito.

---

# 85. Comentarios

Los comentarios deben explicar decisiones o comportamientos que no sean evidentes.

Evitar comentarios innecesarios como:

```gdscript
# mueve al jugador
move_and_slide()
```

Preferir comentarios que expliquen razones:

```gdscript
# La transición se difiere para evitar eliminar CollisionObjects
# durante el callback de física de body_entered.
SceneLoader.call_deferred("next_level")
```

---

# 86. Código temporal de debugging

Los `print()` utilizados para diagnóstico deben eliminarse cuando el problema haya sido solucionado, salvo que formen parte intencional de un sistema de debugging.

Ejemplo temporal:

```gdscript
print("Player position: ", global_position)
```

No debe permanecer indefinidamente en la versión final.

---

# 87. Errores de consola

Antes de integrar un cambio, la consola de Godot no debe contener errores producidos por dicho cambio.

Los warnings deben revisarse y no ignorarse automáticamente.

Si un warning es aceptado intencionalmente, debe existir una razón clara.

---

# 88. SceneLoader

Las transiciones entre niveles se administran a través de:

```text
SceneLoader
```

Los niveles no deben cargar directamente escenas arbitrarias si existe una función centralizada que gestiona esta operación.

La salida del nivel debe solicitar la transición utilizando el sistema correspondiente.

---

# 89. Transiciones desde callbacks de física

Cuando una transición se activa desde señales como:

```text
body_entered
```

se debe evitar eliminar la escena inmediatamente durante el callback de física.

Se utiliza una llamada diferida cuando corresponde.

Ejemplo:

```gdscript
func _on_exit_body_entered(body: Node2D) -> void:
	if body == player:
		SceneLoader.call_deferred("next_level")
```

Esto evita errores relacionados con eliminar `CollisionObject2D` durante procesamiento de física.

---

# 90. Documentación

Las decisiones técnicas importantes deben quedar documentadas.

No debe existir una convención importante conocida únicamente de forma verbal.

Si se crea un nuevo sistema que requiere reglas específicas, dichas reglas deberán agregarse a:

```text
docs/
```

o a este mismo documento cuando corresponda.

---

# 91. Cambios a estas convenciones

Este documento puede evolucionar conforme avance el proyecto.

Si el equipo decide modificar una convención importante:

1. Se discute el cambio.
2. Se determina cómo afecta al proyecto existente.
3. Se actualiza este documento.
4. Se realizan las migraciones necesarias.
5. Se comunica el cambio al equipo.

No deben existir dos estándares diferentes para resolver el mismo problema dentro del proyecto.

---

# 92. Resumen del estándar de niveles

Todo nivel parte de:

```text
level_template.tscn
```

La geometría inicial se construye utilizando:

```text
dev_tileset.tres
```

Significado actual de los tiles:

```text
Gris     → Terrain sólido
Azul     → One-Way Platform
Verde    → Referencia visual de PlayerSpawn
Morado   → Referencia visual de LevelExit
Amarillo → Reservado para referencias futuras
Rojo     → Sin uso oficial actualmente
```

La lógica real se mantiene separada del TileMap:

```text
Gameplay/PlayerSpawn
Gameplay/LevelExit
Gameplay/Entities
Gameplay/Pickups
```

El flujo de desarrollo de un nivel es:

```text
Template
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

---

# 93. Regla principal

> **Primero se valida el gameplay. Después se aplica el arte.**

La estructura, lógica y convenciones del proyecto deben mantenerse consistentes para que todos los integrantes del equipo puedan colaborar sin necesidad de aprender una organización diferente para cada nivel.
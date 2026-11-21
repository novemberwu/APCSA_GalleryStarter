# AP CSA (Units 1–3) + AP Art History — Virtual Museum Starter Kit

## 1. Overview & Pedagogical Design
This Processing (`P3D`) starter project is specifically designed for **AP Computer Science A students who have learned Units 1–3** (**Unit 1:** Primitives, Using Objects, `Math`, `String`; **Unit 2:** Boolean Expressions, `if/else` Selection, and `for`/`while` Loops; **Unit 3:** Class Creation, Constructors, Encapsulation, and Composition) **without requiring Unit 4 (`Array` or `ArrayList`)**.

Each **AP CSA + AP Art History** student pair collaborates to build **one curated gallery room** containing **4 wall paintings, 2 floor statues, and 1 room lighting condition**. The teacher then connects every team's room into a single multi-room museum using the `Doorway` class.

---

## 2. Project File Structure

| File | Owner | Purpose & New AP CSA Standard Concepts |
| :--- | :--- | :--- |
| `Painting.pde` | **Students (Part 1A)** | **Unit 3 (Class Creation), Unit 1 (`Math` & `String`), Unit 2 (Booleans):** Encapsulates one artwork (`title`, `artist`, `yearAndMedium`, `formAndContent`, `historicalContext`, 3D wall coordinates, and `PImage`). |
| `Statue.pde` | **Students (Part 1B)** | **Unit 3 (Class Creation & Overloaded Constructors), Unit 1 (`Math`), Unit 2 (Booleans):** Encapsulates a 3D floor sculpture (`.obj` or marble style, pedestal type, rotation speed, and circular collision). |
| `GalleryLight.pde` | **Students (Part 1C)** | **Unit 3 (Class Creation), Unit 2 (`if/else` Presets), Unit 1 (`Math`):** Encapsulates the room's lighting preset and intensity. |
| `Room1_Mythology.pde` | **Reference Example** | **Units 1–3 Complete Example:** Models *Sala I: Botticelli — Myth & Allegory* with 4 `Painting` fields, 2 `Statue` fields, and 1 `GalleryLight` field, `for` loops (**Unit 2**) for ceiling beams & floor medallions, `if/else-if` (**Unit 2**) proximity detection, and compound boolean (**Unit 2**) wall/pedestal collision. |
| `Room2_StudentTemplate.pde` | **Students (Part 2)** | **Student Room Template (Units 1–3):** Connected to Room 1 via a `Doorway`. Contains step-by-step `// === STUDENT TODO ===` markers for teams to build their own room. |
| `Doorway.pde` | **Teacher Integration** | Renders Pietra Serena stone archways with carved destination signs on the North (`z = -600`) or South (`z = +600`) wall and transitions the visitor between student rooms. |
| `APCSA_GalleryStarter.pde` | **Teacher Integration** | Main sketch that instantiates student rooms, links them with `Doorway` objects, and manages the active `currentRoomId`. |
| `GalleryEngine.pde` | **Teacher Black-Box** | Handles `P3D` camera math, `WASD`/mouse look, gold frames, safe image loading from `data/`, and the 2D Curator HUD + minimap. |

---

## 3. The Room & Doorway Contract (How Student Rooms Plug Together)

Every student room uses **local coordinates centered at `(0, 0)`** (`X` from `-500` to `+500`, `Z` from `-600` to `+600`):

1. **Reserved Doorway Zones (Keep Clear of Paintings):**
   - **North Doorway Slot:** `z = -600`, `x` between `-90` and `+90`
   - **South Doorway Slot:** `z = +600`, `x` between `-90` and `+90`
2. **Standard 4 Painting Slots:**
   - **West Wall:** `x = -492.0f, z = 0.0f` (`"WEST"`)
   - **East Wall:** `x = +492.0f, z = 0.0f` (`"EAST"`)
   - **North-West Wing (Left of North Doorway):** `x = -295.0f, z = -592.0f` (`"NORTH"`)
   - **North-East Wing (Right of North Doorway):** `x = +295.0f, z = -592.0f` (`"NORTH"`)
3. **Required Doorway Hook Methods on Every Student Room Class:**
   - `public boolean isEnteringNorthDoor(float visitorX, float visitorZ)`
   - `public boolean isEnteringSouthDoor(float visitorX, float visitorZ)`
   - `public String getRoomTitle()`
   - `public String getCuratorNames()`

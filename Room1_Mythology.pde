// ============================================================================
// Room1_Mythology.pde — Completed Example Student Room (AP CSA Units 1-3)
// Theme: Sala I — Botticelli's Mythological Masterpieces & Classical Statues
// ============================================================================
// NOTICE HOW THIS CLASS USES ONLY AP CSA UNITS 1-3 (NO UNIT 4 ARRAYS!):
// - Unit 1: Primitive types, Math, String, calling methods on objects
// - Unit 2: if / else if / else selection, compound booleans & for loops
// - Unit 3: Class creation, constructor, encapsulation, composition & doorway hooks
// ============================================================================

class Room1_Mythology {
  // --- [AP CSA UNIT 3: Class Creation] Instance Variables (NO Unit 4 Arrays!) ---
  private String roomTitle;
  private String curatorNames;

  // 4 Individual Painting Object References on the Walls
  private Painting westPainting;       // Primavera
  private Painting eastPainting;       // The Birth of Venus
  private Painting northLeftPainting;  // Pallas and the Centaur (left of North doorway)
  private Painting northRightPainting; // Venus and Mars (right of North doorway)

  // 2 Individual 3D Statue Object References placed on the Gallery Floor!
  private Statue westFloorStatue;      // Venus de' Medici (statue.obj on ROTATING pedestal)
  private Statue eastFloorStatue;      // Medici Classical Krater Vase (vase.obj on BLOCK pedestal)

  // 1 GalleryLight Object Reference encapsulating the room's lighting condition!
  private GalleryLight roomLight;

  // --- [AP CSA UNIT 3: Class Creation] Constructor ---
  public Room1_Mythology(GalleryEngine engine) {
    this.roomTitle = "Sala I: Botticelli — Myth, Allegory & Classical Sculpture";
    this.curatorNames = "Curated by: Sample Team A (AP CSA & AP 2D Art)";

    this.roomLight = new GalleryLight(
      "Uffizi Warm Conservation Light",
      "WARM_MUSEUM",
      0.85f
    );

    // 1. West Wall Masterpiece: Primavera (x = -492, z = 0)
    this.westPainting = new Painting(
      engine,
      "Primavera (Allegory of Spring)",
      "Sandro Botticelli",
      "c. 1480, Tempera on wood panel",
      "Botticelli-primavera.jpg",
      "WEST",
      -492.0f, -15.0f, 0.0f,
      310.0f, 205.0f,
      false,
      "FORM & CONTENT: Nine mythological figures arranged in a rhythmic frieze across an orange grove with 500+ identifiable plant species. Venus stands at the center under a natural arch; Zephyrus pursues Chloris on the right, who transforms into Flora.",
      "CONTEXT (APAH #72 Partner Work): Painted for the Medici family in Florence. Reflects Marsilio Ficino's Neoplatonic philosophy, where physical beauty (Venus) elevates the human soul toward divine wisdom."
    );

    // 2. East Wall Masterpiece: The Birth of Venus (x = +492, z = 0)
    this.eastPainting = new Painting(
      engine,
      "The Birth of Venus",
      "Sandro Botticelli",
      "c. 1484-1486, Tempera on canvas",
      "Botticelli-birth-of-venus.jpg",
      "EAST",
      492.0f, -15.0f, 0.0f,
      290.0f, 190.0f,
      false,
      "FORM & CONTENT: First monumental Renaissance painting on canvas in Tuscany. Venus stands in a classical Venus Pudica contrapposto pose on a gilded scallop shell, blown shoreward by Zephyrus and Aura toward a Hora holding a flowered cloak.",
      "CONTEXT (APAH Required Work #72): Rejects strict linear perspective and anatomical weight in favor of floating, lyrical contour lines and alabaster skin illuminated with powdered gold leaf."
    );

    // 3. North-West Wing (Left of the North Doorway): Pallas and the Centaur
    this.northLeftPainting = new Painting(
      engine,
      "Pallas and the Centaur",
      "Sandro Botticelli",
      "c. 1482, Tempera on canvas",
      "pallas_centaur.png",
      "NORTH",
      -295.0f, -10.0f, -592.0f,
      165.0f, 210.0f,
      false,
      "FORM & CONTENT: Pallas Athena, wreathed in olive branches and Medici diamond rings, gently tames a restless centaur by holding his hair, contrasting serene posture with anguished expression.",
      "CONTEXT: An allegory of reason and chastity governing untamed passion, also celebrating Lorenzo il Magnifico's diplomatic peace mission to Naples."
    );

    // 4. North-East Wing (Right of the North Doorway): Venus and Mars
    this.northRightPainting = new Painting(
      engine,
      "Venus and Mars",
      "Sandro Botticelli",
      "c. 1485, Tempera and oil on panel",
      "venus_and_mars.png",
      "NORTH",
      295.0f, -10.0f, -592.0f,
      220.0f, 115.0f,
      false,
      "FORM & CONTENT: Horizontal spalliera panel. Fully clothed, alert Venus reclines opposite a sleeping, disarmed Mars while four playful baby satyrs steal his helmet and lance.",
      "CONTEXT: Commissioned for a Florentine wedding chamber (camera nuziale) to proclaim the Neoplatonic triumph of Love (Venus) over Strife (Mars)."
    );

    // 5. Floor Statue #1 (West-North quadrant: x = -210, z = -190)
    //    Loads "statue.obj" from data/ onto a classic square BLOCK pedestal!
    this.westFloorStatue = new Statue(
      engine,
      "Venus de' Medici (Classical Prototype)",
      "Hellenistic Greek / Medici Collection",
      "1st Century BCE, Parian Marble (statue.obj)",
      "statue.obj",
      -210.0f, -190.0f,
      "BLOCK",
      35.0f,
      "FORM & CONTENT: Life-size marble sculpture depicting Aphrodite in the modest Venus Pudica contrapposto pose. Displayed on a classic square Pietra Serena block plinth rotating at 35 deg/sec.",
      "CONTEXT: Ancient Roman copies of this Hellenistic sculpture in the Medici gardens directly inspired Sandro Botticelli's pose for The Birth of Venus on the opposite East wall."
    );

    // 6. Floor Statue #2 (East-North quadrant: x = +210, z = -190)
    //    Loads textured "meshy_statue.obj" (+ .mtl + .png) from data/ onto a BLOCK pedestal!
    this.eastFloorStatue = new Statue(
      engine,
      "Palette of King Narmer (APAH #13)",
      "Predynastic Egyptian Royal Workshop",
      "c. 3000-2920 BCE, Greywacke Siltstone (meshy_statue.obj)",
      "meshy_statue.obj",
      210.0f, -190.0f,
      "BLOCK",
      -25.0f,
      "FORM & CONTENT: Shield-shaped ceremonial palette carved in low relief on both sides. Depicts King Narmer wearing the White Crown of Upper Egypt on one side and the Red Crown of Lower Egypt on the reverse, with intertwined serpopards framing the central mixing depression.",
      "CONTEXT (APAH Required Work #13): Excavated at Hierakonpolis; commemorates the unification of Upper and Lower Egypt and establishes the foundational conventions of Egyptian figural representation (composite view, hierarchy of scale, and horizontal registers)."
    );
  }

  // --- [AP CSA UNIT 2 & UNIT 3] Display Room Architecture, Paintings & Statues ---
  public void display(GalleryEngine engine) {
    if (this.roomLight != null) {
      this.roomLight.display(engine);
    }

    // Draw outer walls (with North doorway slot open)
    engine.drawStandardRoomWalls(true, false);

    // [AP CSA UNIT 2: Iteration] Use a for-loop to draw 9 Renaissance wooden ceiling beams
    for (int zPos = -560; zPos <= 560; zPos += 140) {
      engine.drawCeilingBeam(zPos);
    }

    // [AP CSA UNIT 2: Iteration] Use a nested for-loop to draw marble floor inlay medallions
    for (int rowZ = -400; rowZ <= 400; rowZ += 400) {
      for (int colX = -260; colX <= 260; colX += 260) {
        engine.drawFloorMedallion(colX, rowZ);
      }
    }

    // [AP CSA UNIT 1 & UNIT 3] Call display() on each of our 4 Painting objects
    this.westPainting.display(engine);
    this.eastPainting.display(engine);
    this.northLeftPainting.display(engine);
    this.northRightPainting.display(engine);

    // [AP CSA UNIT 1 & UNIT 3] Call display() on each of our 2 Floor Statue objects!
    this.westFloorStatue.display(engine);
    this.eastFloorStatue.display(engine);
  }

  public void drawSouthEntranceWall(GalleryEngine engine) {
    engine.drawClosedDoorwayPanel("SOUTH", "UFFIZI ENTRANCE LOGGIA");
  }

  // --- [AP CSA UNIT 2: Selection] if / else if / else Proximity Check for Paintings ---
  public Painting getActivePainting(float visitorX, float visitorZ) {
    if (this.westPainting.isVisitorNear(visitorX, visitorZ)) {
      return this.westPainting;
    } else if (this.eastPainting.isVisitorNear(visitorX, visitorZ)) {
      return this.eastPainting;
    } else if (this.northLeftPainting.isVisitorNear(visitorX, visitorZ)) {
      return this.northLeftPainting;
    } else if (this.northRightPainting.isVisitorNear(visitorX, visitorZ)) {
      return this.northRightPainting;
    } else {
      return null;
    }
  }

  // --- [AP CSA UNIT 2: Selection] if / else if / else Proximity Check for Floor Statues ---
  public Statue getActiveStatue(float visitorX, float visitorZ) {
    if (this.westFloorStatue.isVisitorNear(visitorX, visitorZ)) {
      return this.westFloorStatue;
    } else if (this.eastFloorStatue.isVisitorNear(visitorX, visitorZ)) {
      return this.eastFloorStatue;
    } else {
      return null;
    }
  }

  // --- [AP CSA UNIT 2: Booleans] Compound Boolean Expressions for Wall & Statue Collision ---
  public boolean canMoveTo(float nextX, float nextZ) {
    boolean insideEastWestWalls = (nextX > -445.0f && nextX < 445.0f);
    boolean insideNorthSouthWalls = (nextZ > -545.0f && nextZ < 545.0f);
    boolean inNorthDoorwayRecess = (nextX > -80.0f && nextX < 80.0f && nextZ <= -545.0f && nextZ > -585.0f);

    boolean insideRoomOrDoor = (insideEastWestWalls && insideNorthSouthWalls) || inNorthDoorwayRecess;

    // Prevent visitor from walking through either floor statue pedestal!
    boolean hitsStatue = this.westFloorStatue.collidesWithVisitor(nextX, nextZ)
                      || this.eastFloorStatue.collidesWithVisitor(nextX, nextZ);

    return insideRoomOrDoor && !hitsStatue;
  }

  // --- REQUIRED DOORWAY INTERFACE METHODS FOR TEACHER INTEGRATION ---
  public boolean isEnteringNorthDoor(float visitorX, float visitorZ) {
    return (visitorX > -80.0f && visitorX < 80.0f && visitorZ <= -562.0f);
  }

  public boolean isEnteringSouthDoor(float visitorX, float visitorZ) {
    return (visitorX > -80.0f && visitorX < 80.0f && visitorZ >= 562.0f);
  }

  public String getRoomTitle() { return this.roomTitle; }
  public String getCuratorNames() { return this.curatorNames; }
  public Statue getWestFloorStatue() { return this.westFloorStatue; }
  public Statue getEastFloorStatue() { return this.eastFloorStatue; }
  public GalleryLight getRoomLight() { return this.roomLight; }
}

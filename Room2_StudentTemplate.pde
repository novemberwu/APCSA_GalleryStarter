// ============================================================================
// Room2_StudentTemplate.pde — Student Starter Template (AP CSA Units 1-3)
// Theme: Sala II — Sacred Tondi, Altarpieces, Portraits & Floor Statues
// ============================================================================
// STUDENT INSTRUCTIONS:
// 1. Copy or rename this class for your team (e.g., Team2_HighRenaissance).
// 2. Drop your 4 artwork images (.png or .jpg) and any 3D statue (.obj) files
//    into the sketch's "data/" folder.
// 3. Complete the TODO sections below using AP CSA Units 1-3 (Paintings + Statues + Light).
// 4. DO NOT block the North (z = -600, x in [-90, 90]) or South (z = +600,
//    x in [-90, 90]) center doorway slots so the teacher's Doorway class can
//    connect your room to the rest of the museum!
// ============================================================================

class Room2_StudentTemplate {
  // === STUDENT TODO 1 (AP CSA Unit 3: Class Creation & Instance Variables) ===
  // Declare your room title, curator names, 4 Painting references, and 2 Statue references:
  private String roomTitle;
  private String curatorNames;

  private Painting westPainting;
  private Painting eastPainting;
  private Painting northLeftPainting;
  private Painting northRightPainting;

  // Floor Statues placed inside the room at (x, z) coordinates:
  private Statue westFloorStatue;
  private Statue eastFloorStatue;

  // Room Lighting Condition (WARM_MUSEUM, NATURAL_DAYLIGHT, DRAMATIC_CHIAROSCURO, SOFT_CONSERVATION):
  private GalleryLight roomLight;

  // === STUDENT TODO 2 (AP CSA Unit 3: Constructor) ===
  public Room2_StudentTemplate(GalleryEngine engine) {
    this.roomTitle = "Sala II: Botticelli — Sacred Tondi, Portraits & Medici Busts";
    this.curatorNames = "Curated by: Your Names Here (AP CSA & AP Art History)";

    this.roomLight = new GalleryLight(
      "Natural Skylight Daylight",
      "NATURAL_DAYLIGHT",
      0.88f
    );

    // 1-4. Instantiate your 4 Wall Painting objects:
    this.westPainting = new Painting(
      engine,
      "Adoration of the Magi",
      "Sandro Botticelli",
      "c. 1475, Tempera on panel",
      "adoration_magi.png",
      "WEST",
      -492.0f, -10.0f, 0.0f,
      245.0f, 200.0f,
      false,
      "FORM & CONTENT: Pyramidal composition set amid classical Roman ruins. Cosimo de' Medici kneels before the Christ Child, flanked by his sons Piero and Giovanni and grandson Lorenzo il Magnifico.",
      "CONTEXT: At the far right edge, a young man in a golden-ochre cloak turns directly toward the viewer — widely recognized as Botticelli's self-portrait."
    );

    this.eastPainting = new Painting(
      engine,
      "Madonna of the Magnificat",
      "Sandro Botticelli",
      "c. 1481, Tempera & gold on circular tondo",
      "madonna_magnificat.png",
      "EAST",
      492.0f, -10.0f, 0.0f,
      210.0f, 210.0f,
      true,
      "FORM & CONTENT: Circular domestic tondo (118 cm diameter). Five wingless angels crown the Virgin Mary beneath a golden celestial disk while she dips a quill to write the Magnificat hymn.",
      "CONTEXT: Notice how the figures curve along the circular frame as if viewed through a convex mirror, demonstrating Botticelli's mastery of non-linear composition."
    );

    this.northLeftPainting = new Painting(
      engine,
      "Madonna of the Pomegranate",
      "Sandro Botticelli",
      "c. 1487, Tempera on circular panel",
      "madonna_pomegranate.png",
      "NORTH",
      -295.0f, -10.0f, -592.0f,
      200.0f, 200.0f,
      true,
      "FORM & CONTENT: Six angels bearing white lilies and rose garlands flank Mary and the Christ Child, who hold a split pomegranate revealing its crimson seeds.",
      "CONTEXT: Commissioned for the Magistrates of the Massai di Camera at Florence's Palazzo Vecchio; the pomegranate symbolizes Christ's Passion and Resurrection."
    );

    this.northRightPainting = new Painting(
      engine,
      "Portrait of a Man with a Medal of Cosimo",
      "Sandro Botticelli",
      "c. 1474-1475, Tempera & gilded gesso on panel",
      "portrait_medal.png",
      "NORTH",
      295.0f, -10.0f, -592.0f,
      155.0f, 195.0f,
      false,
      "FORM & CONTENT: Three-quarter portrait set before a serene river landscape. The young man holds an actual 3D gilded gesso cast of a commemorative medal of Cosimo de' Medici.",
      "CONTEXT: Influenced by Flemish landscapes (Hans Memling), while pioneering tactile multimedia relief inside an Italian Renaissance panel portrait."
    );

    // === STUDENT TODO 2B (Statue Placement on the Gallery Floor) ===
    // You can pass an .obj file in data/ ("statue.obj", "vase.obj") OR a built-in
    // sculpture style ("MEDICI_BUST", "VENUS_MARBLE", "PORPHYRY_URN").
    // Pedestal types: "BLOCK", "ROTATING", or "COLUMN".
    // Keep (x, z) away from the center spawn (0, 260) and doorways (0, +-560)!
    this.westFloorStatue = new Statue(
      engine,
      "Bust of Lorenzo il Magnifico",
      "Florentine Renaissance Workshop",
      "c. 1485, Carrara Marble & Gilded Bronze",
      "MEDICI_BUST",
      -210.0f, -140.0f,
      "COLUMN",
      20.0f,
      "FORM & CONTENT: Portrait bust of Lorenzo de' Medici mounted on a fluted Corinthian column pedestal, rotating gently at 20 degrees per second.",
      "CONTEXT: Patron of Sandro Botticelli and founder of the San Marco sculpture garden where young Florentine artists studied antique marble statuary."
    );

    this.eastFloorStatue = new Statue(
      engine,
      "Imperial Porphyry Medici Urn",
      "Florentine Stonecutters (Opificio delle Pietre Dure)",
      "c. 1480, Red Egyptian Porphyry & Gold Leaf",
      "PORPHYRY_URN",
      210.0f, -140.0f,
      "ROTATING",
      -30.0f,
      "FORM & CONTENT: Carved imperial red porphyry ceremonial vessel with gilded bronze handles and finial, displayed on a twisted ROTATING pedestal.",
      "CONTEXT: Red porphyry was prized by the Medici as the stone of Roman emperors, linking Renaissance Florence to classical antiquity."
    );
  }

  // === STUDENT TODO 3 (AP CSA Unit 2: Loops & Unit 3: Method Calls) ===
  public void display(GalleryEngine engine) {
    if (this.roomLight != null) {
      this.roomLight.display(engine);
    }

    engine.drawStandardRoomWalls(false, true);

    for (int zPos = -560; zPos <= 560; zPos += 140) {
      engine.drawCeilingBeam(zPos);
    }

    for (int zTile = -360; zTile <= 360; zTile += 240) {
      engine.drawFloorMedallion(0, zTile);
    }

    // Display all 4 Wall Paintings
    this.westPainting.display(engine);
    this.eastPainting.display(engine);
    this.northLeftPainting.display(engine);
    this.northRightPainting.display(engine);

    // Display both Floor Statues
    this.westFloorStatue.display(engine);
    this.eastFloorStatue.display(engine);
  }

  public void drawNorthClosedWall(GalleryEngine engine) {
    engine.drawClosedDoorwayPanel("NORTH", "FUTURE ROOM 3 CONNECTION");
  }

  // === STUDENT TODO 4 (AP CSA Unit 2: if / else if / else) ===
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

  // Check if the visitor is standing near one of the 3D floor statues:
  public Statue getActiveStatue(float visitorX, float visitorZ) {
    if (this.westFloorStatue.isVisitorNear(visitorX, visitorZ)) {
      return this.westFloorStatue;
    } else if (this.eastFloorStatue.isVisitorNear(visitorX, visitorZ)) {
      return this.eastFloorStatue;
    } else {
      return null;
    }
  }

  // === STUDENT TODO 5 (AP CSA Unit 2: Compound Booleans + Statue Collision) ===
  public boolean canMoveTo(float nextX, float nextZ) {
    boolean insideEastWestWalls = (nextX > -445.0f && nextX < 445.0f);
    boolean insideNorthSouthWalls = (nextZ > -545.0f && nextZ < 545.0f);
    boolean inSouthDoorwayRecess = (nextX > -80.0f && nextX < 80.0f && nextZ >= 545.0f && nextZ < 585.0f);

    boolean insideRoomOrDoor = (insideEastWestWalls && insideNorthSouthWalls) || inSouthDoorwayRecess;

    boolean hitsStatue = this.westFloorStatue.collidesWithVisitor(nextX, nextZ)
                      || this.eastFloorStatue.collidesWithVisitor(nextX, nextZ);

    return insideRoomOrDoor && !hitsStatue;
  }

  // ==========================================================================
  // DO NOT MODIFY BELOW: Required Doorway Interface for Teacher Integration
  // ==========================================================================
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

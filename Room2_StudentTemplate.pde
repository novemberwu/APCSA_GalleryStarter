// ============================================================================
// Room2_StudentTemplate.pde — Student Starter Template (AP CSA Units 1-3)
// Theme: Sala II — Room Under Construction (Empty Room Ready for Student Team)
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
  // === STUDENT TODO 1 (AP CSA Unit 3: Class Creation & Encapsulation) ===
  private String roomTitle;
  private String curatorNames;

  // Declare 4 Wall Paintings (currently null — instantiate yours in the constructor!)
  private Painting westPainting;
  private Painting eastPainting;
  private Painting northLeftPainting;
  private Painting northRightPainting;

  // Declare 2 Floor Statues (currently null — instantiate yours in the constructor!)
  private Statue westFloorStatue;
  private Statue eastFloorStatue;

  // 1 GalleryLight Object Reference encapsulating the room's lighting condition
  private GalleryLight roomLight;

  // === STUDENT TODO 2 (AP CSA Unit 3: Constructor) ===
  public Room2_StudentTemplate(GalleryEngine engine) {
    this.roomTitle = "Sala II: Room Under Construction";
    this.curatorNames = "Curated by: Your Names Here (AP CSA & AP 2D Art)";

    // Presets: "WARM_MUSEUM", "NATURAL_DAYLIGHT", "DRAMATIC_CHIAROSCURO", "SOFT_CONSERVATION"
    this.roomLight = new GalleryLight(
      "Natural Skylight Daylight",
      "NATURAL_DAYLIGHT",
      0.88f
    );

    // TODO 2A: Instantiate your 4 Wall Painting objects here (see Room1_Mythology.pde for examples):
    this.westPainting = null;
    this.eastPainting = null;
    this.northLeftPainting = null;
    this.northRightPainting = null;

    // TODO 2B: Instantiate your 2 Floor Statue objects here (see Room1_Mythology.pde for examples):
    this.westFloorStatue = null;
    this.eastFloorStatue = null;
  }

  // === STUDENT TODO 3 (AP CSA Unit 2: Loops & Unit 3: Method Calls) ===
  public void display(GalleryEngine engine) {
    if (this.roomLight != null) {
      this.roomLight.display(engine);
    }

    // Bare gallery walls with South archway open to Room 1
    engine.drawStandardRoomWalls(false, true);

    // TODO 3A (AP CSA Unit 2: for-loop): Add ceiling beams using engine.drawCeilingBeam(zPos);
    // TODO 3B (AP CSA Unit 2: for-loop): Add floor decorations using engine.drawFloorMedallion(xPos, zPos);

    // Display your 4 Wall Paintings once instantiated


    // Display your 2 Floor Statues once instantiated

    // Show "ROOM UNDER CONSTRUCTION" sign in the center while the room is empty
    boolean isEmptyRoom = (this.westPainting == null && this.eastPainting == null
                        && this.northLeftPainting == null && this.northRightPainting == null
                        && this.westFloorStatue == null && this.eastFloorStatue == null);
    if (isEmptyRoom) {
      engine.drawUnderConstructionSign(
        "ROOM UNDER CONSTRUCTION",
        "Add your Paintings, Statues & Decor in Room2_StudentTemplate!"
      );
    }
  }

  public void drawNorthClosedWall(GalleryEngine engine) {
    engine.drawClosedDoorwayPanel("NORTH", "FUTURE ROOM 3 CONNECTION");
  }

  // === STUDENT TODO 4 (AP CSA Unit 2: Selection if / else if / else) ===
  public Painting getActivePainting(float visitorX, float visitorZ) {
    if (this.westPainting != null && this.westPainting.isVisitorNear(visitorX, visitorZ)) {
      return this.westPainting;
    } else if (this.eastPainting != null && this.eastPainting.isVisitorNear(visitorX, visitorZ)) {
      return this.eastPainting;
    } else if (this.northLeftPainting != null && this.northLeftPainting.isVisitorNear(visitorX, visitorZ)) {
      return this.northLeftPainting;
    } else if (this.northRightPainting != null && this.northRightPainting.isVisitorNear(visitorX, visitorZ)) {
      return this.northRightPainting;
    } else {
      return null;
    }
  }

  public Statue getActiveStatue(float visitorX, float visitorZ) {
    if (this.westFloorStatue != null && this.westFloorStatue.isVisitorNear(visitorX, visitorZ)) {
      return this.westFloorStatue;
    } else if (this.eastFloorStatue != null && this.eastFloorStatue.isVisitorNear(visitorX, visitorZ)) {
      return this.eastFloorStatue;
    } else {
      return null;
    }
  }

  // === STUDENT TODO 5 (AP CSA Unit 2: Compound Booleans + Collision) ===
  public boolean canMoveTo(float nextX, float nextZ) {
    boolean insideEastWestWalls = (nextX > -445.0f && nextX < 445.0f);
    boolean insideNorthSouthWalls = (nextZ > -545.0f && nextZ < 545.0f);
    boolean inSouthDoorwayRecess = (nextX > -80.0f && nextX < 80.0f && nextZ >= 545.0f && nextZ < 585.0f);

    boolean insideRoomOrDoor = (insideEastWestWalls && insideNorthSouthWalls) || inSouthDoorwayRecess;
    boolean hitsStatue = (this.westFloorStatue != null && this.westFloorStatue.collidesWithVisitor(nextX, nextZ))
                      || (this.eastFloorStatue != null && this.eastFloorStatue.collidesWithVisitor(nextX, nextZ));

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
  public Painting getWestPainting() { return this.westPainting; }
  public Painting getEastPainting() { return this.eastPainting; }
  public Painting getNorthLeftPainting() { return this.northLeftPainting; }
  public Painting getNorthRightPainting() { return this.northRightPainting; }
  public Statue getWestFloorStatue() { return this.westFloorStatue; }
  public Statue getEastFloorStatue() { return this.eastFloorStatue; }
  public GalleryLight getRoomLight() { return this.roomLight; }
}

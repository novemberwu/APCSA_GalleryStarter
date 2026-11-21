// ============================================================================
// Doorway.pde — Teacher Integration Class
// ============================================================================
// Connects one student's Room class to another student's Room class through
// the standardized North (z = -600) or South (z = +600) doorway slots.
//
// STANDARD DOORWAY RESERVATION CONTRACT FOR STUDENTS:
// - Room local coordinates span X: [-500, +500], Z: [-600, +600]
// - North Doorway Opening: X in [-90, +90] at Z = -600
// - South Doorway Opening: X in [-90, +90] at Z = +600
// ============================================================================

class Doorway {
  private String wallSide;         // "NORTH" or "SOUTH"
  private int fromRoomId;
  private int toRoomId;
  private String destinationTitle;
  private float doorX;
  private float doorZ;
  private float spawnX;
  private float spawnZ;
  private float spawnYaw;
  private PImage lintelSignTexture;

  public Doorway(
      String wallSide,
      int fromRoomId,
      int toRoomId,
      String destinationTitle,
      float spawnX,
      float spawnZ,
      float spawnYaw) {

    this.wallSide = wallSide;
    this.fromRoomId = fromRoomId;
    this.toRoomId = toRoomId;
    this.destinationTitle = destinationTitle;
    this.spawnX = spawnX;
    this.spawnZ = spawnZ;
    this.spawnYaw = spawnYaw;

    this.doorX = 0.0f;
    if (wallSide.equals("NORTH")) {
      this.doorZ = -600.0f;
    } else {
      this.doorZ = 600.0f;
    }
  }

  // Draws the Pietra Serena stone doorway frame, portal recess, and lintel sign
  public void display(GalleryEngine engine) {
    if (this.lintelSignTexture == null) {
      String arrowLabel = wallSide.equals("NORTH")
        ? "NORTH ARCHWAY  ->  " + destinationTitle
        : "SOUTH ARCHWAY  ->  " + destinationTitle;
      this.lintelSignTexture = engine.createDoorwaySignTexture(arrowLabel);
    }

    engine.drawDoorwayArchOnWall(this.wallSide, this.lintelSignTexture);
  }

  // Returns true when the visitor is close enough to see the doorway prompt on HUD
  public boolean isVisitorNearArchway(float visitorX, float visitorZ) {
    double dx = visitorX - this.doorX;
    double dz = visitorZ - this.doorZ;
    double dist = Math.sqrt(dx * dx + dz * dz);
    return dist < 210.0;
  }

  // Returns true when the visitor crosses the doorway threshold to switch rooms
  public boolean isVisitorSteppingThrough(float visitorX, float visitorZ) {
    boolean inHorizontalOpening = (visitorX > -80.0f && visitorX < 80.0f);
    if (this.wallSide.equals("NORTH")) {
      return inHorizontalOpening && (visitorZ <= -562.0f);
    } else {
      return inHorizontalOpening && (visitorZ >= 562.0f);
    }
  }

  public int getFromRoomId() {
    return this.fromRoomId;
  }

  public int getToRoomId() {
    return this.toRoomId;
  }

  public String getDestinationTitle() {
    return this.destinationTitle;
  }

  public String getWallSide() {
    return this.wallSide;
  }

  public float getSpawnX() {
    return this.spawnX;
  }

  public float getSpawnZ() {
    return this.spawnZ;
  }

  public float getSpawnYaw() {
    return this.spawnYaw;
  }
}

// ============================================================================
// Painting.pde — AP CSA Unit 3 (Class Creation) + Unit 1 (Math & String)
// ============================================================================
// STUDENT GUIDE:
// Each Painting object represents one artwork curated by your AP Art History
// partner. It encapsulates the painting's 3D position on the wall, its dimensions,
// its loaded PImage texture, and its AP Art History FFCC analysis.
// ============================================================================

class Painting {
  // --- [AP CSA UNIT 3: Class Creation] Private Instance Variables (Encapsulation) ---
  private String title;
  private String artist;
  private String yearAndMedium;
  private String formAndContent;     // AP Art History: Form & Content
  private String historicalContext;  // AP Art History: Function & Context

  // Wall placement & dimensions in 3D space
  private String wallSide;           // "NORTH", "SOUTH", "EAST", or "WEST"
  private float x;
  private float y;
  private float z;
  private float frameWidth;
  private float frameHeight;
  private boolean isCircularTondo;

  // Image texture loaded from the data/ folder (or auto-generated sample)
  private PImage canvasImage;
  private PImage plaqueImage;

  // --- [AP CSA UNIT 3: Class Creation] Constructor ---
  public Painting(
      GalleryEngine engine,
      String title,
      String artist,
      String yearAndMedium,
      String imageFileName,
      String wallSide,
      float x,
      float y,
      float z,
      float frameWidth,
      float frameHeight,
      boolean isCircularTondo,
      String formAndContent,
      String historicalContext) {

    this.title = title;
    this.artist = artist;
    this.yearAndMedium = yearAndMedium;
    this.wallSide = wallSide;
    this.x = x;
    this.y = y;
    this.z = z;
    this.frameWidth = frameWidth;
    this.frameHeight = frameHeight;
    this.isCircularTondo = isCircularTondo;
    this.formAndContent = formAndContent;
    this.historicalContext = historicalContext;

    // [AP CSA UNIT 1] Calling methods on the engine object to create textures
    this.canvasImage = engine.loadOrCreateArtwork(imageFileName, title);
    this.plaqueImage = engine.createWallPlaqueTexture(title, artist, yearAndMedium);
  }

  // --- [AP CSA UNIT 1] Using the Math class (Math.sqrt and Math.pow) ---
  // Calculates the horizontal 2D floor distance between the visitor and this painting.
  public float distanceToVisitor(float visitorX, float visitorZ) {
    double dx = this.x - visitorX;
    double dz = this.z - visitorZ;
    return (float) Math.sqrt(Math.pow(dx, 2) + Math.pow(dz, 2));
  }

  // --- [AP CSA UNIT 2] Boolean Expressions & Return Values ---
  // Returns true if the visitor is standing within viewing distance (250 units).
  public boolean isVisitorNear(float visitorX, float visitorZ) {
    float distance = distanceToVisitor(visitorX, visitorZ);
    return distance < 250.0f;
  }

  // --- [AP CSA UNIT 1] Using String Methods (toUpperCase, indexOf, substring) ---
  // Returns a formatted museum header string for the Curator HUD.
  public String getFormattedHeader() {
    String upperTitle = this.title.toUpperCase();
    return upperTitle + "  |  " + this.artist + " (" + this.yearAndMedium + ")";
  }

  // --- [AP CSA UNIT 3] Instance Method: Display Painting on Wall ---
  public void display(GalleryEngine engine) {
    engine.drawFramedPaintingOnWall(
      this.canvasImage,
      this.plaqueImage,
      this.wallSide,
      this.x,
      this.y,
      this.z,
      this.frameWidth,
      this.frameHeight,
      this.isCircularTondo
    );
  }

  // --- [AP CSA UNIT 3] Accessor (Getter) Methods ---
  public String getTitle() {
    return this.title;
  }

  public String getArtist() {
    return this.artist;
  }

  public String getYearAndMedium() {
    return this.yearAndMedium;
  }

  public String getFormAndContent() {
    return this.formAndContent;
  }

  public String getHistoricalContext() {
    return this.historicalContext;
  }

  public String getWallSide() {
    return this.wallSide;
  }

  public float getX() {
    return this.x;
  }

  public float getZ() {
    return this.z;
  }

  public PImage getCanvasImage() {
    return this.canvasImage;
  }
}

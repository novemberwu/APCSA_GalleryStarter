// ============================================================================
// Statue.pde — AP CSA Unit 3 (Class Creation) + 3D Floor Sculpture Placement
// ============================================================================
// STUDENT GUIDE:
// Each Statue object represents a 3D sculpture or classical vessel placed on
// the gallery floor at coordinates (x, z).
// - Supports loading 3D .obj models from data/ (e.g., "statue.obj", "vase.obj")
//   OR built-in Renaissance marble styles ("VENUS_MARBLE", "MEDICI_BUST", "URN").
// - Supports pedestal types: "BLOCK", "ROTATING" (twisted column), or "COLUMN".
// - Includes collidesWithVisitor(nextX, nextZ) so visitors cannot walk through
//   the pedestal, and isVisitorNear(camX, camZ) to show the AP Art History HUD!
// ============================================================================

class Statue {
  // --- [AP CSA UNIT 3: Class Creation] Private Instance Variables ---
  private String title;
  private String sculptor;
  private String yearAndMedium;
  private String modelOrStyle;      // "statue.obj", "vase.obj", "VENUS_MARBLE", "MEDICI_BUST"
  private String pedestalType;      // "BLOCK", "ROTATING", or "COLUMN"
  private float x;                  // Floor X coordinate (room center is 0)
  private float z;                  // Floor Z coordinate (room center is 0)
  private float rotatingSpeed;      // Degrees per second (0 = stationary)
  private float collisionRadius;    // Floor collision radius around pedestal
  private String formAndContent;    // AP Art History: Form & Content
  private String historicalContext; // AP Art History: Function & Context

  private PShape objModel;
  private float modelScale = 45.0f;
  private float modelCenterX = 0.0f;
  private float modelCenterY = 0.0f;
  private float modelCenterZ = 0.0f;
  private float modelHalfHeight = 50.0f;
  private PImage plaqueImage;
  private PImage previewImage;

  // --- [AP CSA UNIT 3: Class Creation] Constructor 1: Full Statue Constructor ---
  public Statue(
      GalleryEngine engine,
      String title,
      String sculptor,
      String yearAndMedium,
      String modelOrStyle,
      float x,
      float z,
      String pedestalType,
      float rotatingSpeed,
      String formAndContent,
      String historicalContext) {

    this.title = title;
    this.sculptor = sculptor;
    this.yearAndMedium = yearAndMedium;
    this.modelOrStyle = modelOrStyle;
    this.x = x;
    this.z = z;
    this.pedestalType = pedestalType;
    this.rotatingSpeed = rotatingSpeed;
    this.collisionRadius = 72.0f;
    this.formAndContent = formAndContent;
    this.historicalContext = historicalContext;

    if (engine != null) {
      this.plaqueImage = engine.createWallPlaqueTexture(title, sculptor, yearAndMedium);
      this.previewImage = engine.createStatuePreviewThumbnail(title, sculptor, modelOrStyle);
      if (modelOrStyle != null && modelOrStyle.toLowerCase().endsWith(".obj")) {
        engine.loadNormalizedObjStatue(this, modelOrStyle);
      }
    }
  }

  // --- [AP CSA UNIT 3: Class Creation] Constructor 2: Overloaded Constructor (Defaults to BLOCK & 30 deg/s) ---
  public Statue(
      GalleryEngine engine,
      String title,
      String sculptor,
      String yearAndMedium,
      String modelOrStyle,
      float x,
      float z,
      String formAndContent,
      String historicalContext) {
    this(engine, title, sculptor, yearAndMedium, modelOrStyle, x, z, "BLOCK", 30.0f, formAndContent, historicalContext);
  }

  // --- [AP CSA UNIT 1] Using Math.sqrt and Math.pow ---
  // Calculates the horizontal 2D floor distance between the visitor and this statue pedestal.
  public float distanceToVisitor(float visitorX, float visitorZ) {
    double dx = this.x - visitorX;
    double dz = this.z - visitorZ;
    return (float) Math.sqrt(Math.pow(dx, 2) + Math.pow(dz, 2));
  }

  // --- [AP CSA UNIT 2] Boolean Return: Proximity Check for Curator HUD ---
  public boolean isVisitorNear(float visitorX, float visitorZ) {
    return distanceToVisitor(visitorX, visitorZ) < 195.0f;
  }

  // --- [AP CSA UNIT 2] Boolean Return: Pedestal Collision Check ---
  // Returns true if (nextX, nextZ) is too close to the statue pedestal!
  public boolean collidesWithVisitor(float nextX, float nextZ) {
    return distanceToVisitor(nextX, nextZ) < this.collisionRadius;
  }

  // --- [AP CSA UNIT 1] String Formatting for Curator HUD ---
  public String getFormattedHeader() {
    return "[3D STATUE] " + this.title.toUpperCase() + "  |  " + this.sculptor + " (" + this.yearAndMedium + ")";
  }

  // --- [AP CSA UNIT 3] Display Statue & Pedestal in 3D ---
  public void display(GalleryEngine engine) {
    if (engine == null) return;
    engine.drawStatueOnPedestal(this);
  }

  // Package helper called by GalleryEngine when normalizing an OBJ mesh
  public void setNormalizedModel(PShape shape, float cx, float cy, float cz, float scale, float halfH) {
    this.objModel = shape;
    this.modelCenterX = cx;
    this.modelCenterY = cy;
    this.modelCenterZ = cz;
    this.modelScale = scale;
    this.modelHalfHeight = halfH;
  }

  // --- [AP CSA UNIT 3] Accessor (Getter) Methods ---
  public String getTitle() { return this.title; }
  public String getSculptor() { return this.sculptor; }
  public String getYearAndMedium() { return this.yearAndMedium; }
  public String getModelOrStyle() { return this.modelOrStyle; }
  public String getPedestalType() { return this.pedestalType; }
  public float getX() { return this.x; }
  public float getZ() { return this.z; }
  public float getRotatingSpeed() { return this.rotatingSpeed; }
  public float getCollisionRadius() { return this.collisionRadius; }
  public String getFormAndContent() { return this.formAndContent; }
  public String getHistoricalContext() { return this.historicalContext; }
  public PShape getObjModel() { return this.objModel; }
  public float getModelScale() { return this.modelScale; }
  public float getModelCenterX() { return this.modelCenterX; }
  public float getModelCenterY() { return this.modelCenterY; }
  public float getModelCenterZ() { return this.modelCenterZ; }
  public float getModelHalfHeight() { return this.modelHalfHeight; }
  public PImage getPlaqueImage() { return this.plaqueImage; }
  public PImage getPreviewImage() { return this.previewImage; }
}

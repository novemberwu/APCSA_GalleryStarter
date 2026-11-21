// ============================================================================
// GalleryLight.pde — AP CSA Unit 3 (Class Creation) + 3D Museum Lighting
// ============================================================================
// STUDENT GUIDE:
// Each GalleryLight object encapsulates the lighting conditions of a gallery room
// so you can present your paintings and 3D statues without glare or overexposure.
// - Preset styles:
//     "WARM_MUSEUM"          — Warm Uffizi gallery light (ideal for tempera & gold leaf)
//     "NATURAL_DAYLIGHT"     — Balanced neutral skylight (true-to-life photograph colors)
//     "DRAMATIC_CHIAROSCURO" — High-contrast spotlighting with deep Renaissance shadows
//     "SOFT_CONSERVATION"    — Gentle archival low-lux light for delicate panels
// - You can also adjust light intensity (0.20f to 1.40f) or set custom RGB colors!
// ============================================================================

class GalleryLight {
  // --- [AP CSA UNIT 3: Class Creation] Private Instance Variables (Encapsulation) ---
  private String lightName;
  private String presetStyle;
  private int ambientRed;
  private int ambientGreen;
  private int ambientBlue;
  private int spotRed;
  private int spotGreen;
  private int spotBlue;
  private float lightX;
  private float lightY;
  private float lightZ;
  private float intensity;       // 0.20f (dim) to 1.40f (bright), 0.85f = balanced museum standard
  private float canvasExposure;  // Prevents whiteout/overexposure on real painting photographs

  // --- [AP CSA UNIT 3: Class Creation] Constructor 1: Preset Lighting Constructor ---
  public GalleryLight(String lightName, String presetStyle, float intensity) {
    this.lightName = lightName;
    this.lightX = 0.0f;
    this.lightY = -225.0f;
    this.lightZ = 0.0f;
    this.intensity = clampIntensity(intensity);
    applyPreset(presetStyle);
  }

  // --- [AP CSA UNIT 3: Class Creation] Constructor 2: Overloaded Full Custom RGB & Position Constructor ---
  public GalleryLight(
      String lightName,
      int ambientRed, int ambientGreen, int ambientBlue,
      int spotRed, int spotGreen, int spotBlue,
      float lightX, float lightY, float lightZ,
      float intensity) {

    this.lightName = lightName;
    this.presetStyle = "CUSTOM";
    this.ambientRed = clampColor(ambientRed);
    this.ambientGreen = clampColor(ambientGreen);
    this.ambientBlue = clampColor(ambientBlue);
    this.spotRed = clampColor(spotRed);
    this.spotGreen = clampColor(spotGreen);
    this.spotBlue = clampColor(spotBlue);
    this.lightX = lightX;
    this.lightY = lightY;
    this.lightZ = lightZ;
    this.intensity = clampIntensity(intensity);
    this.canvasExposure = 0.92f;
  }

  // --- [AP CSA UNIT 3: Class Creation] Constructor 3: Overloaded Default Constructor (Chains via this(...)) ---
  public GalleryLight() {
    this("Uffizi Warm Conservation Light", "WARM_MUSEUM", 0.85f);
  }

  // --- [AP CSA UNIT 2: Selection] (if / else if / else): Configure Lighting Presets ---
  public void applyPreset(String style) {
    if (style == null) {
      style = "WARM_MUSEUM";
    }
    String upper = style.toUpperCase();
    if ("NATURAL_DAYLIGHT".equals(upper)) {
      this.presetStyle = "NATURAL_DAYLIGHT";
      this.ambientRed = 112;
      this.ambientGreen = 114;
      this.ambientBlue = 118;
      this.spotRed = 118;
      this.spotGreen = 118;
      this.spotBlue = 116;
      this.canvasExposure = 0.96f;
    } else if ("DRAMATIC_CHIAROSCURO".equals(upper)) {
      this.presetStyle = "DRAMATIC_CHIAROSCURO";
      this.ambientRed = 72;
      this.ambientGreen = 66;
      this.ambientBlue = 58;
      this.spotRed = 148;
      this.spotGreen = 128;
      this.spotBlue = 98;
      this.canvasExposure = 0.86f;
    } else if ("SOFT_CONSERVATION".equals(upper)) {
      this.presetStyle = "SOFT_CONSERVATION";
      this.ambientRed = 92;
      this.ambientGreen = 88;
      this.ambientBlue = 82;
      this.spotRed = 96;
      this.spotGreen = 90;
      this.spotBlue = 80;
      this.canvasExposure = 0.84f;
    } else {
      this.presetStyle = "WARM_MUSEUM";
      this.ambientRed = 106;
      this.ambientGreen = 98;
      this.ambientBlue = 88;
      this.spotRed = 122;
      this.spotGreen = 112;
      this.spotBlue = 96;
      this.canvasExposure = 0.92f;
    }
  }

  // --- [AP CSA UNIT 2 & UNIT 3] Mutator: Cycle Through the 4 Museum Lighting Presets ---
  public void cyclePreset() {
    if ("WARM_MUSEUM".equals(this.presetStyle)) {
      applyPreset("NATURAL_DAYLIGHT");
      this.lightName = "Natural Skylight Daylight";
    } else if ("NATURAL_DAYLIGHT".equals(this.presetStyle)) {
      applyPreset("DRAMATIC_CHIAROSCURO");
      this.lightName = "Dramatic Chiaroscuro Spotlight";
    } else if ("DRAMATIC_CHIAROSCURO".equals(this.presetStyle)) {
      applyPreset("SOFT_CONSERVATION");
      this.lightName = "Soft Archival Conservation Light";
    } else {
      applyPreset("WARM_MUSEUM");
      this.lightName = "Uffizi Warm Conservation Light";
    }
  }

  // --- [AP CSA UNIT 1 & UNIT 3] Mutator: Adjust Light Intensity Safely ---
  public void adjustIntensity(float delta) {
    this.intensity = clampIntensity(this.intensity + delta);
  }

  public void setIntensity(float newIntensity) {
    this.intensity = clampIntensity(newIntensity);
  }

  // --- [AP CSA UNIT 3] Apply This Room's Lighting in the 3D Engine ---
  public void display(GalleryEngine engine) {
    if (engine == null) return;
    engine.applyRoomLight(this);
  }

  // --- [AP CSA UNIT 1] String Formatting for HUD Display ---
  public String getFormattedSummary() {
    int pct = Math.round(this.intensity * 100.0f);
    return this.lightName + " [" + this.presetStyle + " | " + pct + "%]";
  }

  private float clampIntensity(float val) {
    return Math.max(0.20f, Math.min(1.40f, val));
  }

  private int clampColor(int c) {
    return Math.max(0, Math.min(255, c));
  }

  // --- [AP CSA UNIT 3] Accessor (Getter) Methods ---
  public String getLightName() { return this.lightName; }
  public String getPresetStyle() { return this.presetStyle; }
  public int getAmbientRed() { return this.ambientRed; }
  public int getAmbientGreen() { return this.ambientGreen; }
  public int getAmbientBlue() { return this.ambientBlue; }
  public int getSpotRed() { return this.spotRed; }
  public int getSpotGreen() { return this.spotGreen; }
  public int getSpotBlue() { return this.spotBlue; }
  public float getLightX() { return this.lightX; }
  public float getLightY() { return this.lightY; }
  public float getLightZ() { return this.lightZ; }
  public float getIntensity() { return this.intensity; }
  public float getCanvasExposure() { return this.canvasExposure; }
}

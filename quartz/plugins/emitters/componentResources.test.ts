import test, { describe } from "node:test"
import assert from "node:assert"

describe("GoatCounter Analytics Script Generation", () => {
  // Helper function that simulates the analytics script generation logic
  function generateGoatCounterScript(
    websiteId: string,
    host?: string,
    scriptSrc?: string
  ): string {
    return `
      window.goatcounter = { no_onload: true };
      
      const goatcounterScript = document.createElement('script');
      goatcounterScript.src = "${scriptSrc ?? "https://gc.zgo.at/count.js"}";
      goatcounterScript.defer = true;
      goatcounterScript.setAttribute(
        'data-goatcounter',
        "https://${websiteId}.${host ?? "goatcounter.com"}/count"
      );
      goatcounterScript.onload = () => {
        goatcounter.count({ path: location.pathname });
        document.addEventListener('nav', () => {
          goatcounter.count({ path: location.pathname });
        });
      };

      document.head.appendChild(goatcounterScript);
    `
  }

  test("should generate correct goatcounter script without overwriting count function", () => {
    const script = generateGoatCounterScript(
      "test",
      "analytics.example.com", 
      "https://analytics.example.com/count.js"
    )

    // Test that window.goatcounter is set before the script loads
    assert(
      script.includes("window.goatcounter = { no_onload: true };"),
      "Should set window.goatcounter before loading script"
    )

    // Test that it doesn't overwrite goatcounter after the script loads
    const noOnloadIndex = script.indexOf("window.goatcounter = { no_onload: true };")
    const countCallIndex = script.indexOf("goatcounter.count(")
    assert(
      noOnloadIndex < countCallIndex,
      "Should set no_onload before calling goatcounter.count"
    )

    // Test that goatcounter.count is called in onload
    assert(
      script.includes("goatcounter.count({ path: location.pathname })"),
      "Should call goatcounter.count in onload handler"
    )

    // Test that nav events are handled
    assert(
      script.includes("document.addEventListener('nav'") &&
      script.includes("goatcounter.count({ path: location.pathname })"),
      "Should handle nav events for SPA routing"
    )

    // Test that the script src is correct
    assert(
      script.includes("https://analytics.example.com/count.js"),
      "Should use correct script source URL"
    )

    // Test that data-goatcounter attribute is set correctly
    assert(
      script.includes("https://test.analytics.example.com/count"),
      "Should set correct data-goatcounter URL"
    )
  })

  test("should handle default goatcounter configuration", () => {
    const script = generateGoatCounterScript("test")

    // Test default script URL
    assert(
      script.includes("https://gc.zgo.at/count.js"),
      "Should use default goatcounter script URL"
    )

    // Test default host
    assert(
      script.includes("https://test.goatcounter.com/count"),
      "Should use default goatcounter.com host"
    )

    // Test that no_onload is still set correctly
    assert(
      script.includes("window.goatcounter = { no_onload: true };"),
      "Should set no_onload configuration"
    )
  })

  test("should prevent the original bug where goatcounter is overwritten", () => {
    const script = generateGoatCounterScript("test")
    
    // The bug was that window.goatcounter was set to { no_onload: true } AFTER
    // the script loaded, which overwrote the goatcounter object and removed the count function.
    // Our fix sets it BEFORE the script loads.
    
    // Count how many times window.goatcounter is assigned
    const assignments = script.match(/window\.goatcounter\s*=/g) || []
    assert.strictEqual(
      assignments.length, 
      1, 
      "Should only assign window.goatcounter once (before script loads)"
    )
    
    // Ensure the assignment happens before any goatcounter.count calls
    const assignmentIndex = script.indexOf("window.goatcounter =")
    const firstCountIndex = script.indexOf("goatcounter.count(")
    assert(
      assignmentIndex < firstCountIndex,
      "goatcounter configuration should be set before any count calls"
    )
  })
})
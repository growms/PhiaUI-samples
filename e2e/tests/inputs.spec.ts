import { test, expect } from "@playwright/test";
import { trackConsoleIssues } from "./helpers/console";
import { waitForLiveView } from "./helpers/live_view";

test.describe("inputs page", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/components/inputs");
    await waitForLiveView(page);
  });

  test("slider updates the displayed value", async ({ page }) => {
    const issues = trackConsoleIssues(page);

    const form = page.locator('form:has(input[name="value"][type="range"])').first();
    const slider = form.locator('input[type="range"]');
    const readout = form.locator("span", { hasText: /%$/ });

    await expect(readout).toHaveText("65%");
    await slider.focus();
    await slider.press("End"); // jumps range input to its max (100)

    await expect(readout).toHaveText("100%");
    expect(issues.filter((i) => i.type !== "warning")).toEqual([]);
  });

  test("radio group selects a new plan", async ({ page }) => {
    const issues = trackConsoleIssues(page);

    // Radios are visually hidden (sr-only) — click the wrapping label.
    await page.locator("label", { hasText: "Enterprise — Custom pricing" }).click();

    const enterpriseInput = page.locator('input[type="radio"][value="enterprise"]');
    await expect(enterpriseInput).toBeChecked();
    // Hold through a server round-trip to confirm the assign persisted.
    await page.waitForTimeout(300);
    await expect(enterpriseInput).toBeChecked();
    expect(issues.filter((i) => i.type !== "warning")).toEqual([]);
  });

  test("combobox search filters options", async ({ page }) => {
    const issues = trackConsoleIssues(page);

    const combo = page.locator("#showcase-fruit");
    // First visible button inside the combobox is the trigger.
    await combo.getByRole("button").first().click();

    const searchInput = combo.locator('input[name="query"]');
    await expect(searchInput).toBeVisible();
    await searchInput.fill("app");

    const options = combo.getByRole("option");
    await expect(options.filter({ hasText: "Apple" })).toBeVisible();
    await expect(options.filter({ hasText: "Banana" })).toHaveCount(0);

    expect(issues.filter((i) => i.type !== "warning")).toEqual([]);
  });

  test("tags input adds and removes tags", async ({ page }) => {
    const issues = trackConsoleIssues(page);

    // Scope to the TagsInput form (unique via its tags-add submit binding).
    const form = page.locator('form[phx-submit="tags-add"]');
    const newTagInput = form.locator('input[name="tag"]');

    await newTagInput.fill("rust");
    await newTagInput.press("Enter");
    // The tag chip renders a "Remove tag X" button — use it as the visibility marker.
    await expect(form.getByRole("button", { name: "Remove tag rust" })).toBeVisible();

    await form.getByRole("button", { name: "Remove tag phoenix" }).click();
    await expect(form.getByRole("button", { name: "Remove tag phoenix" })).toHaveCount(0);

    expect(issues.filter((i) => i.type !== "warning")).toEqual([]);
  });

  test("autocomplete keeps focus and value across keystrokes", async ({ page }) => {
    const issues = trackConsoleIssues(page);

    const input = page.locator("#ac-language");
    await input.focus();
    await page.keyboard.type("Eli", { delay: 40 });

    // If the input were recreated on each keystroke, the value would be just "i".
    await expect(input).toHaveValue("Eli");
    await expect(input).toBeFocused();
    expect(issues.filter((i) => i.type !== "warning")).toEqual([]);
  });
});

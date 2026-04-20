import { test, expect } from "@playwright/test";
import { trackConsoleIssues } from "./helpers/console";

const DEMO_PATHS = [
  "/",
  "/components",
  "/components/inputs",
  "/components/display",
  "/components/feedback",
  "/components/charts",
  "/components/calendar",
  "/components/cards",
  "/components/navigation",
  "/components/tables",
  "/components/upload",
  "/components/media",
  "/components/animation",
  "/components/visual",
  "/components/layout",
];

for (const path of DEMO_PATHS) {
  test(`${path} loads without console errors`, async ({ page }) => {
    const issues = trackConsoleIssues(page);

    await page.goto(path);
    await page.waitForLoadState("networkidle");
    // Give LiveView hooks a beat to mount and possibly throw.
    await page.waitForTimeout(500);

    const errors = issues.filter((i) => i.type === "error" || i.type === "pageerror");
    expect(errors, `unexpected console errors on ${path}:\n${JSON.stringify(errors, null, 2)}`).toEqual([]);
  });
}

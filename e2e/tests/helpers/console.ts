import type { Page, ConsoleMessage } from "@playwright/test";

export type ConsoleIssue = { type: string; text: string; url: string };

const IGNORED = [
  /Permissions policy violation: unload/i,
  /DevTools failed to load source map/i,
];

export function trackConsoleIssues(page: Page): ConsoleIssue[] {
  const issues: ConsoleIssue[] = [];

  const record = (msg: ConsoleMessage) => {
    if (msg.type() !== "error" && msg.type() !== "warning") return;
    const text = msg.text();
    if (IGNORED.some((re) => re.test(text))) return;
    issues.push({ type: msg.type(), text, url: page.url() });
  };

  page.on("console", record);
  page.on("pageerror", (err) => {
    issues.push({ type: "pageerror", text: err.message, url: page.url() });
  });

  return issues;
}

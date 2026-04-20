import type { Page } from "@playwright/test";

declare global {
  interface Window {
    liveSocket?: { isConnected: () => boolean };
  }
}

/** Waits until the LiveSocket is open so that phx-change/click events are delivered. */
export async function waitForLiveView(page: Page, timeout = 5_000): Promise<void> {
  await page.waitForFunction(
    () => typeof window.liveSocket !== "undefined" && window.liveSocket.isConnected(),
    undefined,
    { timeout },
  );
}

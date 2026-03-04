// PhiaUI Drawer Hook — PhiaDrawer
// Implements a sliding drawer panel with focus trap, keyboard navigation,
// backdrop click dismissal, and CSS transform-based animations.

const FOCUSABLE_SELECTORS = [
  "a[href]",
  "button:not([disabled])",
  "input:not([disabled])",
  "select:not([disabled])",
  "textarea:not([disabled])",
  '[tabindex]:not([tabindex="-1"])',
].join(", ");

const PhiaDrawer = {
  mounted() {
    this._panel = this.el.querySelector("[data-drawer-panel]");
    this._backdrop = this.el.querySelector("[data-drawer-backdrop]");
    this._direction = this.el.dataset.direction || "bottom";
    this._previousFocus = document.activeElement;

    this._handleKeydown = (e) => this._onKeydown(e);
    this._handleBackdropClick = (e) => {
      if (e.target === this._backdrop) this._close();
    };
    this._handleCloseBtn = () => this._close();

    document.addEventListener("keydown", this._handleKeydown);

    if (this._backdrop) {
      this._backdrop.addEventListener("click", this._handleBackdropClick);
    }

    const closeBtn = this.el.querySelector("[data-drawer-close]");
    if (closeBtn) {
      closeBtn.addEventListener("click", this._handleCloseBtn);
    }

    this._applyClosedTransform();

    if (!this.el.classList.contains("hidden")) {
      requestAnimationFrame(() => {
        this._applyOpenTransform();
        const first = this._focusableElements()[0];
        if (first) first.focus();
      });
    }

    this._handleTriggerClick = (e) => {
      const trigger = e.target.closest("[data-drawer-trigger]");
      if (trigger && trigger.dataset.drawerTrigger === this.el.id) {
        this._previousFocus = trigger;
        this._open();
      }
    };

    document.addEventListener("click", this._handleTriggerClick);
  },

  destroyed() {
    document.removeEventListener("keydown", this._handleKeydown);
    document.removeEventListener("click", this._handleTriggerClick);
    if (this._backdrop) {
      this._backdrop.removeEventListener("click", this._handleBackdropClick);
    }
    const closeBtn = this.el.querySelector("[data-drawer-close]");
    if (closeBtn) closeBtn.removeEventListener("click", this._handleCloseBtn);
  },

  _open() {
    this.el.classList.remove("hidden");
    this._applyClosedTransform();
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this._applyOpenTransform();
        const first = this._focusableElements()[0];
        if (first) first.focus();
      });
    });
  },

  _close() {
    this._applyClosedTransform();
    const panel = this._panel;
    const el = this.el;
    const prevFocus = this._previousFocus;
    const onTransitionEnd = () => {
      el.classList.add("hidden");
      panel.removeEventListener("transitionend", onTransitionEnd);
      if (prevFocus && prevFocus.focus) prevFocus.focus();
    };
    if (panel) {
      panel.addEventListener("transitionend", onTransitionEnd);
    } else {
      el.classList.add("hidden");
      if (prevFocus && prevFocus.focus) prevFocus.focus();
    }
  },

  _applyClosedTransform() {
    if (!this._panel) return;
    const transforms = {
      bottom: "translateY(100%)",
      top: "translateY(-100%)",
      left: "translateX(-100%)",
      right: "translateX(100%)",
    };
    this._panel.style.transform = transforms[this._direction] || "translateY(100%)";
  },

  _applyOpenTransform() {
    if (!this._panel) return;
    this._panel.style.transform = "translate(0, 0)";
  },

  _focusableElements() {
    if (!this._panel) return [];
    return Array.from(this._panel.querySelectorAll(FOCUSABLE_SELECTORS)).filter(
      (el) => !el.hasAttribute("disabled") && el.tabIndex !== -1
    );
  },

  _trapFocus(e) {
    const focusable = this._focusableElements();
    if (focusable.length === 0) return;
    const first = focusable[0];
    const last = focusable[focusable.length - 1];
    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    }
  },

  _onKeydown(e) {
    if (this.el.classList.contains("hidden")) return;
    if (e.key === "Escape") {
      e.preventDefault();
      this._close();
    } else if (e.key === "Tab") {
      this._trapFocus(e);
    }
  },
};

export default PhiaDrawer;

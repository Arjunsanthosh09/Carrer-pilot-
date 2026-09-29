/* CareerPilot AI — small UI behaviours. No dependencies. */
(function () {
    "use strict";

    var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    /* 1. Count up the stats (auth panel + dashboard cards) once, on load */
    function countUp(el) {
        var match = el.textContent.trim().match(/^([\d,.]+)(.*)$/);
        if (!match) return;
        var target = parseFloat(match[1].replace(/,/g, ""));
        var suffix = match[2];
        var useCommas = match[1].indexOf(",") !== -1;
        var duration = 1400;
        var start = null;

        function format(n) {
            var rounded = Math.round(n);
            return (useCommas ? rounded.toLocaleString("en-US") : String(rounded)) + suffix;
        }

        el.textContent = format(0);
        function tick(ts) {
            if (start === null) start = ts;
            var p = Math.min((ts - start) / duration, 1);
            var eased = 1 - Math.pow(1 - p, 3);
            el.textContent = format(target * eased);
            if (p < 1) requestAnimationFrame(tick);
        }
        setTimeout(function () { requestAnimationFrame(tick); }, 500);
    }

    /* 2. Show / hide password */
    function addPasswordToggles() {
        document.querySelectorAll('input[type="password"]').forEach(function (input) {
            if (input.parentElement.classList.contains("pw-wrap")) return;
            var wrap = document.createElement("div");
            wrap.className = "pw-wrap";
            input.parentNode.insertBefore(wrap, input);
            wrap.appendChild(input);

            var btn = document.createElement("button");
            btn.type = "button";
            btn.className = "pw-toggle";
            btn.textContent = "Show";
            btn.setAttribute("aria-label", "Show password");
            btn.addEventListener("click", function () {
                var show = input.type === "password";
                input.type = show ? "text" : "password";
                btn.textContent = show ? "Hide" : "Show";
                btn.setAttribute("aria-label", show ? "Hide password" : "Show password");
            });
            wrap.appendChild(btn);
        });
    }

    /* 3. Flash messages fade out after a few seconds */
    function autoDismissFlashes() {
        document.querySelectorAll(".flash-messages .flash").forEach(function (flash) {
            setTimeout(function () {
                flash.classList.add("is-leaving");
                setTimeout(function () { flash.remove(); }, 450);
            }, 6000);
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        addPasswordToggles();
        autoDismissFlashes();

        if (!reduceMotion) {
            document.querySelectorAll(".gauge-mini-num, .stat-card .num").forEach(countUp);
        }

        // After the entrance finishes, switch to snappy transitions
        // (used when the student/officer sections swap on signup).
        setTimeout(function () {
            document.documentElement.classList.add("is-loaded");
        }, 1400);
    });
})();
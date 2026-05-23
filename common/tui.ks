// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  tui.ks  —  Simple TUI primitives for kOS terminals                       ║
// ║  Box-drawing helpers, progress bars, tables and text formatting.          ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

// ── String utilities ──

function tui_repeat {
    parameter str, count.
    local result is "".
    from { local i is 0. } until i >= count step { set i to i + 1. } do {
        set result to result + str.
    }
    return result.
}

function tui_pad_left {
    parameter txt, width.
    if txt:length > width {
        return txt:substring(txt:length - width, width).
    }
    return tui_repeat(" ", width - txt:length) + txt.
}

function tui_pad_right {
    parameter txt, width.
    if txt:length > width {
        return txt:substring(0, width).
    }
    return txt + tui_repeat(" ", width - txt:length).
}

function tui_pad_center {
    parameter txt, width.
    if txt:length >= width {
        return txt:substring(0, width).
    }
    local pad is width - txt:length.
    local left is floor(pad / 2).
    local right is pad - left.
    return tui_repeat(" ", left) + txt + tui_repeat(" ", right).
}

// ── Number formatting ──

function tui_fmt_num {
    parameter n, decimals is 1.
    local rounded is round(n, decimals).
    if decimals = 0 { return round(rounded):tostring(). }
    local str is rounded:tostring().
    if not str:contains(".") {
        set str to str + "." + tui_repeat("0", decimals).
    }
    return str.
}

function tui_fmt_pct {
    parameter ratio, decimals is 0.
    return tui_fmt_num(ratio * 100, decimals) + "%".
}

// ── Box drawing ──

function tui_box_top {
    parameter width, title is "".
    if title:length > 0 {
        local avail is width - 4.
        if title:length > avail { set title to title:substring(0, avail). }
        local pad is avail - title:length.
        local left is floor(pad / 2).
        local right is pad - left.
        return "╔" + tui_repeat("═", left) + " " + title + " " + tui_repeat("═", right) + "╗".
    }
    return "╔" + tui_repeat("═", width - 2) + "╗".
}

function tui_box_mid {
    parameter width.
    return "╠" + tui_repeat("═", width - 2) + "╣".
}

function tui_box_bot {
    parameter width.
    return "╚" + tui_repeat("═", width - 2) + "╝".
}

function tui_row {
    parameter width, content.
    local inner is width - 2.
    return "║" + tui_pad_right(content, inner) + "║".
}

function tui_row_center {
    parameter width, content.
    local inner is width - 2.
    return "║" + tui_pad_center(content, inner) + "║".
}

// ── Progress bar ──

function tui_progress {
    parameter width, ratio, label is "".
    local barInner is width - 2.   // inside [ and ]
    local labelPart is "".
    local barPart is "".

    if label:length > 0 {
        set labelPart to label + " ".
        set barInner to width - labelPart:length - 2.
    }

    if barInner < 4 { set barInner to 4. }

    local filled is floor(ratio * barInner).
    if filled < 0 { set filled to 0. }
    if filled > barInner { set filled to barInner. }
    local empty is barInner - filled.

    set barPart to "[" + tui_repeat("█", filled) + tui_repeat("░", empty) + "]".
    return labelPart + barPart.
}

function tui_progress_with_pct {
    parameter width, ratio, label is "".
    local pctStr is " " + tui_pad_left(tui_fmt_pct(ratio, 0), 4).
    local content is tui_progress(width - pctStr:length, ratio, label).
    return content + pctStr.
}

// ── Table helpers ──

// Build a single table row from cell texts and column widths.
// cells: list of strings, widths: list of ints
function tui_table_row {
    parameter cells, widths.
    local result is "".
    local minLen is min(cells:length, widths:length).
    from { local i is 0. } until i >= minLen step { set i to i + 1. } do {
        set result to result + tui_pad_right(cells[i], widths[i]).
    }
    return result.
}

// Build a table separator line like "───────┼─────────┼──────"
function tui_table_sep {
    parameter widths, left, mid, right.
    local result is left.
    from { local i is 0. } until i >= widths:length step { set i to i + 1. } do {
        set result to result + tui_repeat("─", widths[i]).
        if i < widths:length - 1 {
            set result to result + mid.
        }
    }
    return result + right.
}

// ── Spinner ──

function tui_spinner {
    parameter idx.
    local frames is list("◐", "◓", "◑", "◒").
    return frames[mod(idx, frames:length)].
}

// ── Convenience: clear and set cursor ──

function tui_clear {
    clearscreen.
}

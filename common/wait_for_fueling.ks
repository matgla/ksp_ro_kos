runpath("0:/common/tui.ks").

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║         EMEZ INC.  —  PRE-LAUNCH FUELING SYSTEM                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

local termWidth   is 74.
local refreshRate is 0.5.

function count_loaded {
    local count is 0.
    for res in ship:resources {
        if res:capacity > 0 and abs(res:amount - res:capacity) <= 0.01 {
            set count to count + 1.
        }
    }
    return count.
}

function overall_ratio {
    local totalCap is 0.
    local totalAmt is 0.
    for res in ship:resources {
        set totalCap to totalCap + res:capacity.
        set totalAmt to totalAmt + res:amount.
    }
    if totalCap = 0 { return 1. }
    return totalAmt / totalCap.
}

function draw_ui {
    local innerW is termWidth - 2.
    local loadedCount is count_loaded().
    local totalCount  is ship:resources:length.
    local overall     is overall_ratio().
    local allDone     is loadedCount = totalCount.

    // Header
    print tui_box_top(termWidth, "EMEZ INC. — PRE-LAUNCH FUELING").
    print tui_row(termWidth, "  Ship:   " + ship:name).

    local statusTxt is "LOADING".
    if allDone { set statusTxt to "COMPLETE". }
    print tui_row(termWidth, "  Status: " + statusTxt + "  (" + loadedCount + "/" + totalCount + " resources ready)").
    print tui_box_mid(termWidth).

    // Table header
    local colW is list(18, 22, 30).
    print "║" + tui_pad_right(tui_table_row(
        list("Resource", "Amount / Capacity", "Progress"),
        colW
    ), innerW) + "║".

    print "║" + tui_pad_right("  " + tui_table_sep(list(16, 22, 28), "─", "─┼─", "─"), innerW) + "║".

    // Resource rows
    for res in ship:resources {
        local nameStr is res:name.
        if nameStr:length > 16 { set nameStr to nameStr:substring(0, 16). }
        local ratio is 0.
        if res:capacity > 0 { set ratio to res:amount / res:capacity. }

        local cells is list(
            nameStr,
            tui_fmt_num(res:amount) + " / " + tui_fmt_num(res:capacity),
            tui_progress_with_pct(28, ratio, "")
        ).
        print "║" + tui_pad_right("  " + tui_table_row(cells, colW), innerW) + "║".
    }

    // Footer
    print tui_box_mid(termWidth).
    print tui_row(termWidth, "  " + tui_progress_with_pct(termWidth - 6, overall, "Overall Progress:")).

    local spinIdx is mod(round(time:seconds * 2), 4).
    local msg is tui_spinner(spinIdx) + "  Waiting for fuel to be loaded...".
    if allDone {
        set msg to "*  All resources fully loaded. Ready for launch.".
    }
    print tui_row(termWidth, "  " + msg).
    print tui_box_bot(termWidth).
}

// ── Main loop ──
local procedureFinished is false.

until procedureFinished {
    tui_clear().
    draw_ui().
    wait refreshRate.

    local allLoaded is true.
    for res in ship:resources {
        if res:capacity > 0 and abs(res:amount - res:capacity) > 0.01 {
            set allLoaded to false.
            break.
        }
    }
    if allLoaded { set procedureFinished to true. }
}

// Final static frame
tui_clear().
draw_ui().
wait 1.

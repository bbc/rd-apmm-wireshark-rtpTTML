-- Lua Dissector for TTML
-- Author: James Sandford (james.sandford@bbc.co.uk)
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
--
------------------------------------------------------------------------------------------------
do
    local ttml = Proto("ttml", "TTML")

    local prefs = ttml.prefs
    prefs.dyn_pt = Pref.uint("TTML dynamic payload type", 0, "The value > 95")

    local F = ttml.fields

    F.RES = ProtoField.uint16("ttml.Reserved", "Reserved Bits", base.RANGE_STRING, {0,0,""})
    F.LEN = ProtoField.uint16("ttml.Length", "Length", base.HEX)
    F.DATA = ProtoField.string("ttml.PayloadData", "Payload Data", base.UNICODE)

    function ttml.dissector(tvb, pinfo, tree)
       local subtree = tree:add(ttml, tvb(),"TTML Data")
       subtree:add(F.RES, tvb(0,2))
       subtree:add(F.LEN, tvb(2,2))
       subtree:add(F.DATA, tvb(4))
    end

    -- register dissector to dynamic payload type dissectorTable
    local dyn_payload_type_table = DissectorTable.get("rtp_dyn_payload_type")
    dyn_payload_type_table:add("ttml", ttml)

    -- register dissector to RTP payload type
    local payload_type_table = DissectorTable.get("rtp.pt")
    local old_dissector = nil
    local old_dyn_pt = 0
    function ttml.init()
        if (prefs.dyn_pt ~= old_dyn_pt) then
            if (old_dyn_pt > 0) then
                if (old_dissector == nil) then
                    payload_type_table:remove(old_dyn_pt, ttml)
                else
                    payload_type_table:add(old_dyn_pt, old_dissector)
                end
            end
            old_dyn_pt = prefs.dyn_pt
            old_dissector = payload_type_table:get_dissector(old_dyn_pt)
            if (prefs.dyn_pt > 0) then
                payload_type_table:add(prefs.dyn_pt, ttml)
            end
        end
    end
end

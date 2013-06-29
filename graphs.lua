--[[
Get your server status!
Author: Shawn Nguyen 
--]]

require 'cairo'

function conky_check_server()
  if conky_window == nil then 
    return 
  end

  local cs = cairo_xlib_surface_create(conky_window.display, 
    conky_window.drawable, conky_window.visual, conky_window.width, 
    conky_window.height)
  cr = cairo_create(cs)

  local updates = tonumber(conky_parse('${updates}'))

  font="Dejavu Sans"
  font_size=9
  server = '74.125.23.131'
  server_status = ping_server(server)
  text=server .. ': ' .. server_status
  xpos,ypos=5,425
  red,green,blue,alpha=1,1,1,1
  font_slant=CAIRO_FONT_SLANT_NORMAL
  font_face=CAIRO_FONT_WEIGHT_NORMAL

  cairo_select_font_face (cr, font, font_slant, font_face);
  cairo_set_font_size (cr, font_size)
  cairo_set_source_rgba (cr,red,green,blue,alpha)
  cairo_move_to (cr,xpos,ypos)
  cairo_show_text (cr,text)
  cairo_stroke (cr)

  cairo_destroy(cr)
  cairo_surface_destroy(cs)
  cr=nil
end

function ping_server(server_ip) 
  cmd = 'ping -c 1 -W 3 ' .. server_ip
  local ping = io.popen(cmd, 'r')
  ping:close()
  local rc = io.popen('echo $?', 'r') --get return code
  local out = rc:read('*a')
  rc:close()
  if out == 0 then return "Up" end
  return "Down"
end

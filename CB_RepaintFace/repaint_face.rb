##
##  repaint_face - Tool to quickly paint over a face, even if it's nested in a group or component
##
##  1) Select the Repaint Face tool from the plugins menu.  
##  2) Choose a color
##  3) double click on any face to repaint it
##
##   I borrowed heavily from TIGs addvertex+ tool, and from Rick Wilson's repaint script
##
##
##	  Vesrion 1.1.0
##    9/7/2010, Clark Bremer - clark@diytf.com   Tested on SU6, 7, 8, 13 -  PC only
##

require 'sketchup.rb'

module CB_RF
class RepaintFace

def getCursorID(filename, hotx, hoty)
	cursorPath = Sketchup.find_support_file(filename, "Plugins/CB_RepaintFace")
	if cursorPath
		id = UI.create_cursor(cursorPath, hotx, hoty)
	else
		id=0
	end
	return id
end


def pick_color
	colorNames=Sketchup::Color.names
	prompts=["Choose Painting Color: "]
	@repaint_color = "" if not @repaint_color 
	values=[@repaint_color]
	enums=[colorNames.join('|')] 
	results=UI.inputbox(prompts,values,enums,"Repaint with Color") 
	if !results 
		return
	else
		@repaint_color = results[0]
	end
end

def initialize
	@status="Double-click a face to paint."
	pick_color
	@cursor_id=getCursorID("rpf.png",0,0)
end 

def reset
	@ip=Sketchup::InputPoint.new
end

def activate
	self.reset
	@model=Sketchup.active_model
	Sketchup.set_status_text(@status)
end

def onSetCursor()
	cursor = UI::set_cursor(@cursor_id)
end

def onLButtonDown(flags,x,y,view)
	@model.start_operation("Repaint Face")
	ph=@model.active_view.pick_helper
	ph.do_pick(x,y)
	picked_element=ph.best_picked
	@ip.pick(view,x,y)
	if not @ip.valid?
		picked_element=nil
	end
	if(picked_element) 
		return if not picked_element.instance_of? Sketchup::ComponentInstance
		ci = picked_element
	else
		@model.selection.clear
		return
	end 
	

	
	if( (flags & MK_SHIFT) ==  0 )
		@model.selection.clear
	end	
	@model.selection.add(ci)
	
	Sketchup.set_status_text(@status)
	@model.commit_operation
end 

def onLButtonDoubleClick(flags,x,y,view)
	@model.start_operation("Repaint Face")
	ph=@model.active_view.pick_helper
	ph.do_pick(x,y)
	picked_face=ph.picked_face
	@ip.pick(view,x,y)
	if not @ip.valid?
		picked_face=nil
	end
	if(picked_face)
		picked_face.material = @repaint_color
	else
		UI.beep
		Sketchup.set_status_text(@status)
		return
	end 
	Sketchup.set_status_text(@status)
	@model.commit_operation
end 

end # class RepaintFace

### menu
is_this_file=File.basename(__FILE__)
if not file_loaded?(is_this_file)
  UI.menu("Plugins").add_item("Repaint Face"){Sketchup.active_model.select_tool(RepaintFace.new)}
  file_loaded(is_this_file)
end

end # module CB_RF
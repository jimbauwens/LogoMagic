Turtle = class()

function Turtle:init(gc, x, y, angle)
	self.y	=	0
	self.x	=	0
	self.angle	=	angle or 0 
	self.pen	=	true
	
	self.color	=	{0, 0, 0}
	self.unit	=	1
	
	self.parts	=	{}
	self.gc	=	gc
	self.homex	=	x
	self.homey	=	y
end


function Turtle:penUp()
	self.pen = false
end

function Turtle:penDown()
	self.pen = true
end

function Turtle:moveForward(l)
	local oldx = self.x
	local oldy = self.y
	local radian = math.rad(self.angle)
	
	self.y = oldy + l * math.cos(radian)
	self.x = oldx + l * math.sin(radian)
	
	if self.pen then
		--self.gc:setColorRGB(unpack(self.color))
		self.gc:drawLine(self.homex + oldx,self.homey - oldy,self.homex +  self.x,self.homey - self.y)
	end
end 

function Turtle:setxy(x, y)
	x	=	x or self.x
	y	=	y or self.y
	
	if self.pen then
		self.gc:drawLine(self.homex + self.x,self.homey - self.y, self.homex + x, self.homey - y)
	end
	self.x	=	x
	self.y	=	y
end

function Turtle:rotateTurtle(angle)
	self.angle = self.angle - angle
	if self.angle<360 then
		self.angle = self.angle+360
	end
end

function Turtle:setColor(r, g, b)
	self.color = {r, g, b}
	self.gc:setColorRGB(r,g,b)
end

function Turtle:circle(s)
	self.pen	=	false
	
	self:rotateTurtle(90)
	self:moveForward(s/2)
	
	self.gc:drawArc(self.homex+self.x-s/2, self.homey+self.y-s/2, s, s, 0, 360)

	self:moveForward(-s/2)	
	self:rotateTurtle(-90)	

	self.pen	=	true
end

_big=""

function print(str)
	local gc	= t.gc
	local w	
	if #_big<#str then
		w		= gc:getStringWidth(str)
		_big = str
	else
		w		= gc:getStringWidth(_big)
	end
	
	gc:setColorRGB(255,255,255)
	gc:fillRect(2,6,w,16)
	gc:setColorRGB(0,0,0)
	gc:setFont("sansserif", "r", 12)
	gc:drawString(str,2,2, "top")
end

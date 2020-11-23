;
;***************************** WYZNACZANIE POZIOMU ZAPLAMIENIA SLONCA ********************************
;********************************* Karolina Wojtaczka ************************************************
;
;_______________READING THE FITS FILE_________________________________________________________________
;WINDOW, 0, XSIZE=1024, YSIZE=1024


pro LocateSunspot, current_point, sunspot, sun_image
FORWARD_FUNCTION LocateSunspot
  black = 100
  white = 180
  x = current_point[0]
  y = current_point[1]
  sun_image[x,y] = white
  sunspot.add, [x,y]
  
  for i = x-1, x+1 do begin
    for j = y-1, y+1 do begin
      if sun_image[i, j] EQ black then begin
        LocateSunspot, [i, j], sunspot, sun_image
      endif
    endfor
  endfor
end


READ_JPEG, 'C:\Users\Ryneqq\Desktop\KW\20120104_054500_1024_HMIIF.jpg', sun, /grayscale
WINDOW, 0, XSIZE=1024, YSIZE=1024
tvscl,sun


white = 180
black = 100
;cntr = CONTOUR(sun, N_LEVELS=3, /overplot)
img_size = 1024
center = img_size / 2
sun_radius = 482
sun_image = sun > black < white ;!!!!!!!!!!!!!!!!!!!!!!!!! CONDITION
sunspots = LIST()

for x = 0L, img_size-1 do begin
    for y = 0L, img_size-1 do begin
        distance = SQRT((x - center) ^ 2 + (y - center) ^ 2)
        if sun_radius GT distance then begin
            if sun_image[x,y] EQ black then begin
              sunspot = List()
              LocateSunspot, [x,y], sunspot, sun_image
              sunspots.add, sunspot
            endif
        endif else begin
          sun_image[x,y] = white
        endelse
    endfor
endfor

;for i = 0L, sunspots.count() do begin
;  sunspot = sunspots[i]
  
;  for j = 0L, sunspot.count() do begin
;    for k = 0L, sunspot.count() do begin
;      
;    endfor
;  endfor
;endfor


img = IMAGE(sun_image,IMAGE_DIMENSIONS=[img_size, img_size],DIMENSIONS=[img_size, img_size])



sun_borderline = ELLIPSE(512, 512, TARGET=img,/DATA, MAJOR=482., COLOR='blue', THICK=1.5, FILL_BACKGROUND=0)

print, sunspots
end
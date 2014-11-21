function resp = eyesareopened(Im_face, xl, yl, xr, yr)
    resp = 0.5*isopenedfft(Im_face, xl, yl)+0.5*isopenedfft(Im_face, xr, yr);
end
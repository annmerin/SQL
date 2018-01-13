DECLARE @P INT
SET @P = 3
DECLARE @PRIME VARCHAR(MAX)
SET @PRIME = '2&'
DECLARE @I INT
SET @I = 2
DECLARE @S INT
SET @S = 2

WHILE @P <= 1000
BEGIN
	WHILE @I <= @S AND @P <= 1000
	BEGIN
		IF @P % @I = 0
			BEGIN
			SET @P = @P + 1
			SET @I = 2
			SET @S = ROUND(SQRT(@P),0)
			END
		ELSE
			BEGIN
			SET @I = @I + 1
			IF @I > @S
				BEGIN
				SET @I = 2
				SET @PRIME = CONCAT(@PRIME,CONCAT(@P,'&'))
				SET @P = @P +1
				SET @S = ROUND(SQRT(@P),0)
				END
			END
	END
END

PRINT LEFT(@PRIME,LEN(@PRIME)-1)
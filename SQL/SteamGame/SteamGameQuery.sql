/*
Steam game Data exploration
Skills used: Aggregate Functions, Join table, Converting Data Types, Subquery
*/


-- Explore columns
--SELECT *
--FROM PortfolioProject..steamGames
--ORDER BY appid

--SELECT *
--FROM PortfolioProject..steamPlayers
--ORDER BY appid


-- Highest price games
SELECT TOP 100
	name,
	developer,
	price
FROM PortfolioProject..steamGames
ORDER BY price DESC


-- Calculate avg game price in 2018
SELECT
	AVG(price) AS avg_price
FROM PortfolioProject..steamGames
WHERE YEAR(release_date) = 2018


-- Average playtime vs Positive ratings
SELECT
	name,
	players.average_playtime as avg_playtime,
	games.positive_ratings,
	games.positive_ratings/(games.positive_ratings+games.negative_ratings)*100 AS percentPosRating
FROM PortfolioProject..steamGames games
JOIN PortfolioProject..steamPlayers players
ON games.appid = players.appid
ORDER BY games.positive_ratings DESC


-- Find no. of mac support games in each year
SELECT
	YEAR(release_date) AS release_year,
	COUNT(*) AS supportMac
FROM PortfolioProject..steamGames
WHERE platforms LIKE '%mac%'
GROUP BY YEAR(release_date)
ORDER BY release_year


-- Shows no. of games in each platforms
SELECT
	gameSupport.support,
	COUNT(*) AS n
FROM
(SELECT
	name,
	games.platforms,
	CASE
		WHEN games.platforms = 'windows' THEN 'windows only'
		WHEN games.platforms = 'mac' THEN 'mac only'
		ELSE 'multiple platforms'
	END AS support
FROM PortfolioProject..steamGames games
JOIN PortfolioProject..steamPlayers players
ON games.appid = players.appid
) AS gameSupport
GROUP BY gameSupport.support
ORDER BY n DESC


-- Shows game owners range
SELECT DISTINCT owners
FROM PortfolioProject..steamPlayers


-- Shows amount of games in each game owners range
SELECT owners,
	CAST(TRIM(SUBSTRING(owners, CHARINDEX('-', owners)+1, LEN(owners))) AS int) AS rangeMaxOwners, 
	COUNT(*) AS amountGames
FROM PortfolioProject..steamPlayers
GROUP BY owners
ORDER BY rangeMaxOwners ASC


-- Find distinct genres
SELECT value AS genres
FROM PortfolioProject..steamGames  
    CROSS APPLY STRING_SPLIT(genres, ';')
GROUP BY value
ORDER BY value


-- Find games with Free to Play tag but price is not zero, a DLC ?
SELECT
	name,
	genres,
	price
FROM PortfolioProject..steamGames
WHERE genres LIKE '%Free to Play%' AND price > 0
ORDER BY price DESC



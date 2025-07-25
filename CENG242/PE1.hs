module PE1 where

data Author = Author String Int deriving (Eq, Show)
data Book = Book String Author Int Int deriving (Eq, Show)
data Library = Library [(Book, Int, Int)] deriving (Eq, Show)

---------- Do not change anything above this line ----------

publicationAge :: Book -> Int
publicationAge (Book _ (Author _ birthYear) publishingYear _) = publishingYear - birthYear


booksByAuthor :: Author -> Library -> [Book]
booksByAuthor x library = filter (\(Book _ author _ _) -> author == x) (getBooks library)

shortBooks :: Library -> [Book]
shortBooks library = filter (\(Book _ (Author _ _) _ pageNumber) -> pageNumber < 200) (getBooks library)

bookInCollection :: String -> Library -> Bool
bookInCollection x library =if null bookFound then False else True
                            where 
                                bookFound = filter (\(Book bo (Author _ _) _ _) -> bo == x)  (getBooks library)

totalPagesByAuthor :: Author -> Library -> Int
totalPagesByAuthor x (Library []) = 0
totalPagesByAuthor x (Library ((Book _ author _ pages, _, _):xs))
  | author == x = pages + totalPagesByAuthor x (Library xs)
  | otherwise   = totalPagesByAuthor x (Library xs)

averageBookLength :: Library -> Int
averageBookLength library
  | booksCount == 0 = 0
  | otherwise = totalPages `div` booksCount
  where
    books = getBooks library
    totalPages = sum (map (\(Book _ _ _ pages) -> pages) books)
    booksCount = length books


authorsWithLongBooks :: Int -> Library -> [Author]
authorsWithLongBooks targetPage library = foldl addAuthor [] authorList
                            where
                                books = getBooks (library)
                                authorList = [author | (Book _ author _ pages) <- books, pages >= targetPage]
                                addAuthor authorsFinal author
                                    | author `elem` authorsFinal = authorsFinal
                                    | otherwise = authorsFinal ++ [author]

findYoungestAuthor :: Library -> Author
findYoungestAuthor library = getAuthor (findYoungest y ys)
  where
    books = getBooks library
    (y:ys) = books

    findYoungest min [] = min
    findYoungest min (x:xs)
      | publicationAge x < publicationAge min = findYoungest x xs
      | otherwise = findYoungest min xs

    getAuthor (Book _ a _ _) = a

newArrivals :: Library -> [(Int, Book)] -> Library
newArrivals (Library books) arrivals = Library (foldl updateLibrary books arrivals)
  where
    updateLibrary [] (count, newBook) =
      [(newBook, count, count)]

    updateLibrary ((b, total, available) : xs) (count, newBook)
      | b == newBook = (b, total + count, available + count) : xs
      | otherwise = (b, total, available) : updateLibrary xs (count, newBook)

-- This is a helper function that gives you a list of just the books in a library,
-- with the [Book] type, without the library availability information.
-- It might come in handy for many questions.
-- You may change and improve it to better fit you solution, if you want to.
getBooks :: Library -> [Book]
getBooks (Library books) = map (\(x,_,_) -> x) books

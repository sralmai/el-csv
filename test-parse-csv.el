(require 'ert)
(require 'parse-csv)

(ert-deftest parse-csv->list ()
  "Test CSV rows are correctly split into lists.
Empty fields become empty strings."
  (should (equal (parse-csv->list "cat") '("cat")))
  (should (equal (parse-csv->list "cat,dog") '("cat" "dog")))
  (should (equal (parse-csv->list "cat,dog,goat") '("cat" "dog" "goat")))
  (should (equal (parse-csv->list "cat,,goat") '("cat" "" "goat")))
  (should (equal (parse-csv->list ",,goat") '("" "" "goat")))
  (should (equal (parse-csv->list ",,goat,") '("" "" "goat" "")))
  (should (equal (parse-csv->list ",,,") '("" "" "" ""))))

(ert-deftest parse-csv->list/spaces-surrounding-fields-are-stripped ()
  "Spaces inside and surrounding fields are preserved."
  (should (equal (parse-csv->list " cat ") '(" cat ")))
  (should (equal (parse-csv->list "cat,sausage dog,goat") '("cat" "sausage dog" "goat"))))

(ert-deftest parse-csv->list/quotes-surrounding-fields-are-stripped ()
  "Quotes surrounding fields should be stripped."
  (should (equal (parse-csv->list
                  "cat,\"sausage dog\",goat")
                 '("cat" "sausage dog" "goat"))))

(ert-deftest parse-csv->list/spaces-inside-quotes-are-retained ()
  "Quotes preserve leading and trailing spaces."
  (should (equal (parse-csv->list "\" cat\"") '(" cat")))
  (should (equal (parse-csv->list "\"cat \"") '("cat ")))
  (should (equal (parse-csv->list "\" cat \"") '(" cat "))))

(ert-deftest parse-csv->list/commas-inside-quotes-are-retained ()
  "Quotes preserve commas embedded in fields."
  (should (equal (parse-csv->list "\",cat\"") '(",cat")))
  (should (equal (parse-csv->list "\"cat,\"") '("cat,")))
  (should (equal (parse-csv->list "\",cat,\"") '(",cat,"))))

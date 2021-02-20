;;; package --- Summary
;;; Commentary:

;;; Code:
(quail-define-package
 "jh-test" "UTF-8" "jh-t" t
 "Input method for Indic transliteration with postfix modifiers.

     Long vowels are dealt with by doubling.

     |                  | postfix | examples             |
     |------------------+---------+----------------------|
     | macron           |         | aa  -> ā    ee  -> ē |
     | diacritic below  | .       | d.  -> ḍ    rr. -> ṝ |
     | diacritic above  | '       | s'  -> ś    n'  -> ṅ |
     | tilde            | ~       | n~  -> ñ             |
  "
 nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ;; long vowels
 ("aa" "ā")
 ("ii" "ī")
 ("uu" "ū")
 ("rr." "ṝ")
 ("ee" "ē")
 ("oo" "ō")

 ;; dot below
 ("r." "ṛ")
 ("l." "ḷ")
 ("m." "ṃ")
 ("h." "ḥ")
 ("t." "ṭ")
 ("d." "ḍ")
 ("n." "ṇ")
 ("s." "ṣ")
 
 ;; diacritic above
 ("n'" "ṅ")
 ("s'" "ś")
 ("n~" "ñ"))


(provide 'jh-quail-test)

;;; jh-quail-test.el ends here

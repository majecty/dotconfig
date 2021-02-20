;;; package --- Summary
;;; Commentary:

;;; Code:

(require 'hangul)
[1 2 (+ 1 2)]
(vector 1 2 (+ 1 2))
(defconst hangulshinp2-keymap
  (vector 33	       ;; !
   47	       ;; " to /
   35	       ;; #
   36	       ;; $
   37	       ;; %
   38	       ;; &
   (+ 28 92)   ;; ' to ㅌ(초)
   40	       ;; (
   41	       ;; )
   42	       ;; *
   43	       ;; +
   44	       ;; ,
   45	       ;; -
   46	       ;; .
   (+ 27 92)   ;; / to ㅋ(초)
   48	       ;; 0
   49	       ;; 1
   50	       ;; 2
   51	       ;; 3
   52	       ;; 4
   53	       ;; 5
   54	       ;; 6
   55	       ;; 7
   56	       ;; 8
   57	       ;; 9
   58	       ;; :
   (+ 18 92)   ;; ; to ㅂ(초)
   60	       ;; <
   61	       ;; =
   62	       ;; >
   (+ 39 34)   ;; ? to ㅗ
   64	       ;; @
   (+ 48 34)   ;; A to ㅠ
   (+ 44 34)   ;; B to ㅜ
   (+ 36 34)   ;; C to ㅔ
   (+ 51 34)   ;; D to ㅣ
   (+ 32 34)   ;; E to ㅐ
   (+ 31 34)   ;; F to ㅏ
   (+ 49 34)   ;; G to ㅡ
   (+ 4 86)    ;; H to ㄴ(초성) TODO
   (+ 17 92)   ;; I to ㅁ(초성) TODO
   39	       ;; J to '
   34	       ;; K to "
   (+ 24 92)   ;; L to ㅈ(초성) TODO
   (+ 30 92)   ;; M to ㅎ(초성) TODO
   (+ 21 92)   ;; N to ㅅ(초성) TODO
   (+ 26 92)   ;; O to ㅊ(초성) TODO
   (+ 29 92)   ;; P to ㅍ(초성) TODO
   (+ 34 34)   ;; Q to ㅒ
   (+ 35 34)   ;; R to ㅓ
   (+ 38 34)   ;; S to ㅖ
   (+ 37 34)   ;; T to ㅕ
   (+ 7 92)    ;; U to ㄷ(초성) TODO
   (+ 39 34)   ;; V to ㅗ
   (+ 33 34)   ;; W to ㅑ
   (+ 43 34)   ;; X to ㅛ
   (+ 9 92)    ;; Y to ㄹ(초성) TODO
   17	       ;; Z to ㅁ(종성) TODO
   91	       ;; [
   92	       ;; \
   93	       ;; ]
   94	       ;; ^
   95	       ;; _
   96	       ;; `
   23	       ;; a to ㅇ(종성)
   26	       ;; b to ㅊ(종성)
   1	       ;; c to ㄱ(종성)
   30	       ;; d to ㅎ(종성)
   18	       ;; e to ㅂ(종성)
   29	       ;; f to ㅍ(종성)
   7	       ;; g to ㄷ(종성)
   (+ 4 86)    ;; h to ㄴ(초성)
   (+ 17 92)   ;; i to ㅁ(초성)
   (+ 23 92)   ;; j to ㅇ(초성)
   (+ 1 86)    ;; k to ㄱ(초성)
   (+ 24 92)   ;; l to ㅈ(초성)
   (+ 30 92)   ;; m to ㅎ(초성)
   (+ 21 92)   ;; n to ㅅ(초성)
   (+ 26 92)   ;; o to ㅊ(초성)
   (+ 29 92)   ;; p to ㅍ(초성)
   5	       ;; q to ㅅ(종성)
   28	       ;; r to ㅌ(종성)
   4	       ;; s to ㄴ(종성)
   27	       ;; t to ㅋ(종성)
   (+ 7 92)    ;; u to ㄷ(초성)
   24	       ;; v to ㅈ(종성)
   9	       ;; w to ㄹ(종성)
   22	       ;; x to ㅆ(종성)
   9	       ;; y to ㄹ(종성)
   17	       ;; z to ㅁ(종성)
   123	       ;; {
   124	       ;; |
   125	       ;; }
   126	       ;; ~
   ))

(defun hangul3-shinp2-input-method-internal (key)
  (let ((char (aref hangulshinp2-keymap (- key 33))))
    (cond ((or (and (> char 86) (< char 91))
               (and (> char 96) (< char 123)))
           (hangul3-input-method-cho (- char (if (< char 97) 86 92))))
          ((and (> char 64) (< char 86))
           (hangul3-input-method-jung (- char 34)))
          ((< char 31)
           (hangul3-input-method-jong char))
          (t
           (setq hangul-queue (make-vector 6 0))
           (insert (decode-char 'ucs char))
           (move-overlay quail-overlay (point) (point)))))
)

(defun hangul3-shinp2-input-method (key)
  "3-Bulsik shin p2 input method."
  (if (or buffer-read-only (< key 33) (>= key 127))
      (list key)
    (quail-setup-overlays nil)
    (let ((input-method-function nil)
          (echo-keystrokes 0)
          (help-char nil))
      (setq hangul-queue (make-vector 6 0))
      (hangul3-shinp2-input-method-internal key)
      (unwind-protect
          (catch 'exit-input-loop
            (while t
              (let* ((seq (read-key-sequence nil))
                     (cmd (lookup-key hangul-im-keymap seq))
                     key)
                (cond ((and (stringp seq)
                            (= 1 (length seq))
                            (setq key (aref seq 0))
                            (and (>= key 33) (< key 127)))
                       (hangul3-shinp2-input-method-internal key))
                      ((commandp cmd)
                       (call-interactively cmd))
                      (t
                       (setq unread-command-events
                             (nconc (listify-key-sequence seq)
                                    unread-command-events))
                       (throw 'exit-input-loop nil))))))
       (quail-delete-overlays)))))

(register-input-method
 "korean-hangul3shinp2"
 "UTF-8"
 'hangul-input-method-activate
 "한3신p2"
 "Hangul 3-Bulsik shin p2 Input"
 'hangul3-shinp2-input-method
 "Input method: korean-hangul3shinp2 (mode line indicator:한3신p2)\n\nHangul 3-Bulsik shin p2 input method.")

(provide 'jh-not-quail-test)

;;; jh-not-quail-test.el ends here

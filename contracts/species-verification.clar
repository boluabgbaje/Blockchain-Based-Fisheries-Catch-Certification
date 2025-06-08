;; Species Verification Contract
;; Manages fish species identification and validation

(define-map verified-species
  { species-name: (string-ascii 50) }
  {
    scientific-name: (string-ascii 100),
    is-protected: bool,
    min-size: uint,
    max-quota: uint,
    season-start: uint,
    season-end: uint
  }
)

(define-map species-catches
  { species-name: (string-ascii 50), period: uint }
  { total-caught: uint }
)

;; Add verified species (admin function)
(define-public (add-verified-species
  (species-name (string-ascii 50))
  (scientific-name (string-ascii 100))
  (is-protected bool)
  (min-size uint)
  (max-quota uint)
  (season-start uint)
  (season-end uint)
)
  (begin
    (asserts! (> (len species-name) u0) (err u400))

    (map-set verified-species
      { species-name: species-name }
      {
        scientific-name: scientific-name,
        is-protected: is-protected,
        min-size: min-size,
        max-quota: max-quota,
        season-start: season-start,
        season-end: season-end
      }
    )
    (ok true)
  )
)

;; Verify species catch is legal
(define-public (verify-species-catch
  (species-name (string-ascii 50))
  (weight uint)
  (catch-date uint)
)
  (let ((species-data (unwrap! (map-get? verified-species { species-name: species-name }) (err u404)))
        (current-period (/ catch-date u144)) ;; Approximate weekly periods
        (current-total (get-species-total species-name current-period)))

    ;; Check if species is protected
    (asserts! (not (get is-protected species-data)) (err u405))

    ;; Check quota limits
    (asserts! (<= (+ current-total weight) (get max-quota species-data)) (err u406))

    ;; Check season
    (asserts! (and (>= catch-date (get season-start species-data))
                   (<= catch-date (get season-end species-data))) (err u407))

    ;; Update catch totals
    (map-set species-catches
      { species-name: species-name, period: current-period }
      { total-caught: (+ current-total weight) }
    )

    (ok true)
  )
)

;; Get species information
(define-read-only (get-species-info (species-name (string-ascii 50)))
  (map-get? verified-species { species-name: species-name })
)

;; Get species catch total for period
(define-read-only (get-species-total (species-name (string-ascii 50)) (period uint))
  (default-to u0 (get total-caught (map-get? species-catches { species-name: species-name, period: period })))
)

;; Check if species catch is within limits
(define-read-only (is-catch-legal (species-name (string-ascii 50)) (weight uint) (catch-date uint))
  (match (map-get? verified-species { species-name: species-name })
    species-data
      (let ((current-period (/ catch-date u144))
            (current-total (get-species-total species-name current-period)))
        (and
          (not (get is-protected species-data))
          (<= (+ current-total weight) (get max-quota species-data))
          (>= catch-date (get season-start species-data))
          (<= catch-date (get season-end species-data))
        )
      )
    false
  )
)

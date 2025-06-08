;; Fishing Vessel Verification Contract
;; Manages registration and verification of commercial fishing vessels

(define-map vessels
  { vessel-id: uint }
  {
    owner: principal,
    vessel-name: (string-ascii 50),
    license-number: (string-ascii 30),
    registration-date: uint,
    is-active: bool,
    vessel-type: (string-ascii 20)
  }
)

(define-map vessel-owners
  { owner: principal }
  { vessel-count: uint }
)

(define-data-var next-vessel-id uint u1)

;; Register a new fishing vessel
(define-public (register-vessel (vessel-name (string-ascii 50)) (license-number (string-ascii 30)) (vessel-type (string-ascii 20)))
  (let ((vessel-id (var-get next-vessel-id))
        (caller tx-sender))
    (asserts! (> (len vessel-name) u0) (err u400))
    (asserts! (> (len license-number) u0) (err u401))

    (map-set vessels
      { vessel-id: vessel-id }
      {
        owner: caller,
        vessel-name: vessel-name,
        license-number: license-number,
        registration-date: block-height,
        is-active: true,
        vessel-type: vessel-type
      }
    )

    (map-set vessel-owners
      { owner: caller }
      { vessel-count: (+ (get-vessel-count caller) u1) }
    )

    (var-set next-vessel-id (+ vessel-id u1))
    (ok vessel-id)
  )
)

;; Deactivate a vessel
(define-public (deactivate-vessel (vessel-id uint))
  (let ((vessel-data (unwrap! (map-get? vessels { vessel-id: vessel-id }) (err u404))))
    (asserts! (is-eq (get owner vessel-data) tx-sender) (err u403))

    (map-set vessels
      { vessel-id: vessel-id }
      (merge vessel-data { is-active: false })
    )
    (ok true)
  )
)

;; Get vessel information
(define-read-only (get-vessel (vessel-id uint))
  (map-get? vessels { vessel-id: vessel-id })
)

;; Check if vessel is active and owned by caller
(define-read-only (is-vessel-owner (vessel-id uint) (owner principal))
  (match (map-get? vessels { vessel-id: vessel-id })
    vessel-data (and (get is-active vessel-data) (is-eq (get owner vessel-data) owner))
    false
  )
)

;; Get vessel count for owner
(define-read-only (get-vessel-count (owner principal))
  (default-to u0 (get vessel-count (map-get? vessel-owners { owner: owner })))
)

;; CreditFlow - Advanced DeFi Credit Protocol
;;
;; Summary: Revolutionary peer-to-peer lending platform that transforms 
;; traditional borrowing through intelligent credit assessment and adaptive 
;; risk management on Bitcoin's most secure Layer 2 infrastructure.
;;
;; Description: CreditFlow pioneers the next generation of decentralized 
;; finance by eliminating the need for excessive collateralization through 
;; sophisticated on-chain reputation systems. Borrowers earn trust through 
;; consistent repayment behavior, unlocking progressively better loan terms, 
;; reduced collateral requirements, and competitive interest rates. Built 
;; on Stacks Layer 2, CreditFlow combines Bitcoin's unmatched security with 
;; smart contract flexibility to create a truly decentralized credit ecosystem 
;; where financial reputation becomes a valuable, portable digital asset.
;;
;; Key Innovations:
;; - Intelligent credit scoring algorithm (50-100 scale)
;; - Risk-adjusted collateral optimization
;; - Performance-based interest rate determination
;; - Portfolio management with multi-loan support
;; - Automated default resolution mechanisms
;; - Immutable transaction history and reputation tracking

;; CONSTANTS & CONFIGURATION

;; Contract Administration
(define-constant CONTRACT-OWNER tx-sender)

;; Error Codes
(define-constant ERR-UNAUTHORIZED (err u1))
(define-constant ERR-INSUFFICIENT-BALANCE (err u2))
(define-constant ERR-INVALID-AMOUNT (err u3))
(define-constant ERR-LOAN-NOT-FOUND (err u4))
(define-constant ERR-LOAN-DEFAULTED (err u5))
(define-constant ERR-INSUFFICIENT-SCORE (err u6))
(define-constant ERR-ACTIVE-LOAN (err u7))
(define-constant ERR-NOT-DUE (err u8))
(define-constant ERR-INVALID-DURATION (err u9))
(define-constant ERR-INVALID-LOAN-ID (err u10))

;; Credit Score Parameters
(define-constant MIN-SCORE u50)                ;; Minimum possible credit score
(define-constant MAX-SCORE u100)               ;; Maximum possible credit score
(define-constant MIN-LOAN-SCORE u70)           ;; Minimum score required for loan eligibility

;; System Limits
(define-constant MAX-ACTIVE-LOANS u5)          ;; Maximum active loans per user
(define-constant MAX-LOAN-DURATION u52560)     ;; ~1 year in blocks (10min blocks)

;; DATA STRUCTURES

;; User Credit Profiles
;; Comprehensive credit history and scoring data for each user
(define-map UserScores
  { user: principal }
  {
    score: uint,                    ;; Current credit score (50-100)
    total-borrowed: uint,           ;; Lifetime STX borrowed
    total-repaid: uint,             ;; Lifetime STX repaid
    loans-taken: uint,              ;; Total number of loans taken
    loans-repaid: uint,             ;; Total number of loans repaid
    last-update: uint,              ;; Block height of last score update
  }
)

;; Individual Loan Records
;; Complete loan data including terms, status, and repayment progress
(define-map Loans
  { loan-id: uint }
  {
    borrower: principal,            ;; Loan recipient
    amount: uint,                   ;; Principal amount in STX
    collateral: uint,               ;; Collateral locked in STX
    due-height: uint,               ;; Block height when loan is due
    interest-rate: uint,            ;; Interest rate percentage
    is-active: bool,                ;; Whether loan is currently active
    is-defaulted: bool,             ;; Whether loan has defaulted
    repaid-amount: uint,            ;; Amount repaid so far
  }
)

;; User Active Loan Tracking
;; Maps users to their currently active loan IDs for efficient lookup
(define-map UserLoans
  { user: principal }
  { active-loans: (list 20 uint) }
)

;; STATE VARIABLES

;; Auto-incrementing loan ID counter
(define-data-var next-loan-id uint u0)

;; Total STX locked as collateral across all loans
(define-data-var total-stx-locked uint u0)
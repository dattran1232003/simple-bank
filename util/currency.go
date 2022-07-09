package util

// Constants for all supported currencies
const (
	USD = "USD"
	EUR = "EUR"
	VND = "VND"
)

// IsSupportedCurrency return true if given currency is supported
func IsSupportedCurrency(currency string) bool {
	switch currency {
	case USD, EUR, VND:
		return true
	}
	return false
}

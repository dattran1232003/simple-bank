package token

import (
	"fmt"
	"time"

	"github.com/o1egl/paseto"
)

const (
	minSecretKeySize = 32
)

// PasetoMaker is a PASETO token maker
type PasetoMaker struct {
	paseto      *paseto.V2
	symetricKey []byte
}

func NewPasetoMaker(symetricKey string) (Maker, error) {
	if len(symetricKey) < minSecretKeySize {
		return nil, fmt.Errorf("invalid key size: must be at least %d character", minSecretKeySize)
	}
	return &PasetoMaker{
		paseto:      paseto.NewV2(),
		symetricKey: []byte(symetricKey),
	}, nil

}
func (maker *PasetoMaker) CreateToken(username string, duration time.Duration) (string, error) {
	payload, err := NewPayload(username, duration)
	if err != nil {
		return "", nil
	}
	return maker.paseto.Encrypt(maker.symetricKey, payload, nil)
}

func (maker *PasetoMaker) VerifyToken(token string) (*Payload, error) {
	payload := &Payload{}
	err := maker.paseto.Decrypt(token, maker.symetricKey, payload, nil)
	if err != nil {
		return nil, ErrorInvalidToken
	}

	err = payload.Valid()
	if err != nil {
		return nil, ErrorExpiredToken
	}

	return payload, nil
}

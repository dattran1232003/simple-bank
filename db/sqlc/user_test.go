package db

import (
	"context"
	"testing"
	"time"

	"github.com/dattran1232003/simple-bank/util"
	"github.com/stretchr/testify/require"
)

func createRandomUser(t *testing.T) User {

	arg := CreateUserParams{
		Username:       util.RandomOwner(),
		HashedPassword: "secret",
		FullName:       util.RandomOwner(),
		Email:          util.RandomEmail(),
	}

	user, err := testQueries.CreateUser(context.Background(), arg)
	require.NoError(t, err)

	require.Equal(t, arg.Username, user.Username)
	require.Equal(t, arg.Email, user.Email)
	require.Equal(t, arg.FullName, user.FullName)
	require.Equal(t, arg.HashedPassword, user.HashedPassword)

	require.True(t, user.PasswordChangedAt.IsZero())
	require.NotZero(t, user.CreatedAt)

	return user
}

func TestCreateUser(t *testing.T) {
	createRandomUser(t)
}

func TestGetUser(t *testing.T) {
	createdUser := createRandomUser(t)
	user, err := testQueries.GetUser(context.Background(), createdUser.Username)
	require.NoError(t, err)
	require.NotEmpty(t, user)

	require.Equal(t, user.Username, createdUser.Username)
	require.Equal(t, createdUser.Email, user.Email)
	require.Equal(t, createdUser.FullName, user.FullName)
	require.Equal(t, createdUser.HashedPassword, user.HashedPassword)
	require.Equal(t, createdUser.CreatedAt, user.CreatedAt)
	require.Equal(t, createdUser.PasswordChangedAt, user.PasswordChangedAt)

	require.WithinDuration(t, createdUser.CreatedAt, user.CreatedAt, time.Second)

}

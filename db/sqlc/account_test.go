package db

import (
	"context"
	"database/sql"
	"testing"
	"time"

	"github.com/dattran1232003/simple-bank/util"
	"github.com/stretchr/testify/require"
)

func createRandomAccount(t *testing.T) Account {
	user := createRandomUser(t)

	arg := CreateAccountParams{
		Owner:    user.Username,
		Balance:  util.RandomMoney(),
		Currency: util.RandomCurrency(),
	}

	account, err := testQueries.CreateAccount(context.Background(), arg)
	require.NoError(t, err)

	require.Equal(t, arg.Owner, account.Owner)
	require.Equal(t, arg.Currency, account.Currency)
	require.Equal(t, arg.Balance, account.Balance)

	require.NotZero(t, account.ID)
	require.NotZero(t, account.CreatedAt)

	return account
}

func TestCreateAccount(t *testing.T) {
	createRandomAccount(t)
}

func TestGetAccount(t *testing.T) {
	createdAccount := createRandomAccount(t)
	account, err := testQueries.GetAccount(context.Background(), createdAccount.ID)
	require.NoError(t, err)
	require.NotEmpty(t, account)

	require.Equal(t, account.ID, createdAccount.ID)
	require.Equal(t, createdAccount.Owner, account.Owner)
	require.Equal(t, createdAccount.Currency, account.Currency)
	require.Equal(t, createdAccount.Balance, account.Balance)
	require.WithinDuration(t, createdAccount.CreatedAt, account.CreatedAt, time.Second)

}

func TestUpdateAccount(t *testing.T) {
	createdAccount := createRandomAccount(t)

	arg := UpdateAccountParams{
		ID:      createdAccount.ID,
		Balance: util.RandomMoney(),
	}

	// make sure old and new account balance is always difference
	for arg.Balance == createdAccount.Balance {
		arg.Balance = util.RandomMoney()
	}

	updatedAccount, err := testQueries.UpdateAccount(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, updatedAccount)

	require.Equal(t, updatedAccount.ID, createdAccount.ID)
	require.Equal(t, createdAccount.Owner, updatedAccount.Owner)
	require.Equal(t, createdAccount.Currency, updatedAccount.Currency)
	require.NotEqual(t, createdAccount.Balance, updatedAccount.Balance)
	require.WithinDuration(t, createdAccount.CreatedAt, updatedAccount.CreatedAt, time.Second)
}

func TestDeleteAccount(t *testing.T) {
	createdAccount := createRandomAccount(t)
	err := testQueries.DeleteAccount(context.Background(), createdAccount.ID)
	require.NoError(t, err)

	deletedAccount, err := testQueries.GetAccount(context.Background(), createdAccount.ID)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, deletedAccount)

}

func TestListAccounts(t *testing.T) {
	var lastAccount Account
	const limit = 5
	for i := 0; i < limit; i++ {
		lastAccount = createRandomAccount(t)
	}

	arg := ListAccountsParams{
		Owner:  lastAccount.Owner,
		Limit:  limit,
		Offset: 0,
	}

	accounts, err := testQueries.ListAccounts(context.Background(), arg)
	require.NoError(t, err)

	for _, account := range accounts {
		require.NotEmpty(t, account)
		require.Equal(t, lastAccount.Owner, account.Owner)
	}

}

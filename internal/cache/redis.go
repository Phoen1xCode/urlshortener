package cache

import (
	"context"
	"encoding/json"
	"time"

	"github.com/Phoen1xCode/urlshortener/internal/repo"
	"github.com/redis/go-redis/v9"
)

// 	SetURL(ctx context.Context, url repo.Url) error

type RedisCache struct {
	client *redis.Client
}

func NewRedisCache()

func (c *RedisCache) SetURL(ctx context.Context, url repo.Url) error {
	data, err := json.Marshal(url)
	if err != nil {
		return err
	}

	if err := c.client.Set(ctx, url.ShortCode, data, time.Until(url.ExpiredAt)).Err(); err != nil {
		return err
	}

	return nil
}

func (c *RedisCache) GetURL(ctx context.Context, shortCode string) (*repo.Url, error) {
	data, err := c.client.Get(ctx, shortCode).Bytes()
	if err == redis.Nil {
		return nil, nil
	}
 
	if err != nil {
		return nil, err
	}

	var url repo.Url
	if err := json.Unmarshal(data, &url); err != nil {
		return nil, err
	}
	
	return &url, nil
}

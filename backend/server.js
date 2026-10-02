const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Built-in Mock Data Fallback (used if CoinGecko API rate limits or is offline)
const MOCK_COINS = [
  {
    id: 'bitcoin',
    symbol: 'btc',
    name: 'Bitcoin',
    image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
    current_price: 64250.50,
    market_cap: 1265000000000,
    market_cap_rank: 1,
    total_volume: 28400000000,
    high_24h: 65100.00,
    low_24h: 63800.00,
    price_change_24h: 1250.50,
    price_change_percentage_24h: 1.98,
    circulating_supply: 19750000,
    total_supply: 21000000,
    max_supply: 21000000,
    ath: 73750.07,
    sparkline_in_7d: {
      price: [62000, 62400, 61800, 63100, 62900, 63500, 64250.50]
    }
  },
  {
    id: 'ethereum',
    symbol: 'eth',
    name: 'Ethereum',
    image: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
    current_price: 3480.75,
    market_cap: 418000000000,
    market_cap_rank: 2,
    total_volume: 14200000000,
    high_24h: 3520.00,
    low_24h: 3410.00,
    price_change_24h: -45.25,
    price_change_percentage_24h: -1.28,
    circulating_supply: 120200000,
    total_supply: 120200000,
    max_supply: null,
    ath: 4891.70,
    sparkline_in_7d: {
      price: [3550, 3520, 3490, 3510, 3470, 3450, 3480.75]
    }
  },
  {
    id: 'solana',
    symbol: 'sol',
    name: 'Solana',
    image: 'https://assets.coingecko.com/coins/images/4128/large/solana.png',
    current_price: 145.20,
    market_cap: 67800000000,
    market_cap_rank: 3,
    total_volume: 3100000000,
    high_24h: 149.80,
    low_24h: 139.50,
    price_change_24h: 5.70,
    price_change_percentage_24h: 4.08,
    circulating_supply: 467000000,
    total_supply: 580000000,
    max_supply: null,
    ath: 260.06,
    sparkline_in_7d: {
      price: [136, 138, 140, 142, 139, 143, 145.20]
    }
  },
  {
    id: 'binancecoin',
    symbol: 'bnb',
    name: 'BNB',
    image: 'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png',
    current_price: 575.40,
    market_cap: 85200000000,
    market_cap_rank: 4,
    total_volume: 980000000,
    high_24h: 582.00,
    low_24h: 568.00,
    price_change_24h: 3.20,
    price_change_percentage_24h: 0.56,
    circulating_supply: 148000000,
    total_supply: 148000000,
    max_supply: 200000000,
    ath: 720.67,
    sparkline_in_7d: {
      price: [565, 570, 568, 572, 571, 574, 575.40]
    }
  },
  {
    id: 'ripple',
    symbol: 'xrp',
    name: 'XRP',
    image: 'https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png',
    current_price: 0.585,
    market_cap: 32900000000,
    market_cap_rank: 5,
    total_volume: 1150000000,
    high_24h: 0.602,
    low_24h: 0.571,
    price_change_24h: -0.012,
    price_change_percentage_24h: -2.01,
    circulating_supply: 56300000000,
    total_supply: 99990000000,
    max_supply: 100000000000,
    ath: 3.84,
    sparkline_in_7d: {
      price: [0.59, 0.60, 0.58, 0.595, 0.588, 0.582, 0.585]
    }
  },
  {
    id: 'cardano',
    symbol: 'ada',
    name: 'Cardano',
    image: 'https://assets.coingecko.com/coins/images/975/large/cardano.png',
    current_price: 0.382,
    market_cap: 13700000000,
    market_cap_rank: 6,
    total_volume: 340000000,
    high_24h: 0.395,
    low_24h: 0.375,
    price_change_24h: 0.008,
    price_change_percentage_24h: 2.14,
    circulating_supply: 35800000000,
    total_supply: 45000000000,
    max_supply: 45000000000,
    ath: 3.10,
    sparkline_in_7d: {
      price: [0.365, 0.370, 0.368, 0.375, 0.378, 0.380, 0.382]
    }
  },
  {
    id: 'avalanche-2',
    symbol: 'avax',
    name: 'Avalanche',
    image: 'https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png',
    current_price: 27.60,
    market_cap: 10900000000,
    market_cap_rank: 7,
    total_volume: 420000000,
    high_24h: 28.50,
    low_24h: 26.80,
    price_change_24h: 0.90,
    price_change_percentage_24h: 3.37,
    circulating_supply: 395000000,
    total_supply: 445000000,
    max_supply: 720000000,
    ath: 146.22,
    sparkline_in_7d: {
      price: [25.5, 26.0, 25.8, 26.9, 26.7, 27.2, 27.60]
    }
  },
  {
    id: 'dogecoin',
    symbol: 'doge',
    name: 'Dogecoin',
    image: 'https://assets.coingecko.com/coins/images/5/large/dogecoin.png',
    current_price: 0.118,
    market_cap: 17200000000,
    market_cap_rank: 8,
    total_volume: 680000000,
    high_24h: 0.124,
    low_24h: 0.113,
    price_change_24h: -0.003,
    price_change_percentage_24h: -2.48,
    circulating_supply: 146000000000,
    total_supply: 146000000000,
    max_supply: null,
    ath: 0.737,
    sparkline_in_7d: {
      price: [0.121, 0.123, 0.119, 0.122, 0.120, 0.117, 0.118]
    }
  },
  {
    id: 'polkadot',
    symbol: 'dot',
    name: 'Polkadot',
    image: 'https://assets.coingecko.com/coins/images/12171/large/polkadot.png',
    current_price: 4.85,
    market_cap: 6900000000,
    market_cap_rank: 9,
    total_volume: 180000000,
    high_24h: 4.98,
    low_24h: 4.75,
    price_change_24h: 0.08,
    price_change_percentage_24h: 1.68,
    circulating_supply: 1420000000,
    total_supply: 1480000000,
    max_supply: null,
    ath: 55.00,
    sparkline_in_7d: {
      price: [4.65, 4.70, 4.68, 4.78, 4.75, 4.80, 4.85]
    }
  },
  {
    id: 'chainlink',
    symbol: 'link',
    name: 'Chainlink',
    image: 'https://assets.coingecko.com/coins/images/877/large/chainlink-new-logo.png',
    current_price: 11.45,
    market_cap: 6980000000,
    market_cap_rank: 10,
    total_volume: 240000000,
    high_24h: 11.80,
    low_24h: 11.10,
    price_change_24h: 0.25,
    price_change_percentage_24h: 2.23,
    circulating_supply: 608000000,
    total_supply: 1000000000,
    max_supply: 1000000000,
    ath: 52.88,
    sparkline_in_7d: {
      price: [10.80, 11.10, 10.95, 11.20, 11.15, 11.30, 11.45]
    }
  }
];

const MOCK_GLOBAL = {
  active_cryptocurrencies: 14850,
  total_market_cap_usd: 2380000000000,
  total_volume_24h_usd: 72500000000,
  market_cap_change_percentage_24h_usd: 1.42,
  bitcoin_dominance: 53.15,
  ethereum_dominance: 17.56
};

// Generate realistic chart data for 1D, 7D, 30D
function generateChartPoints(currentPrice, days) {
  const points = [];
  const now = Date.now();
  const numPoints = days === 1 ? 24 : (days === 7 ? 28 : 30);
  const timeInterval = (days * 24 * 3600 * 1000) / numPoints;
  
  let basePrice = currentPrice * (days === 1 ? 0.98 : (days === 7 ? 0.92 : 0.85));
  for (let i = 0; i <= numPoints; i++) {
    const timestamp = now - ((numPoints - i) * timeInterval);
    const variance = (Math.random() - 0.48) * (currentPrice * 0.02);
    const progressFactor = i / numPoints;
    let pointPrice = basePrice + (currentPrice - basePrice) * progressFactor + variance;
    if (i === numPoints) pointPrice = currentPrice;
    points.push([timestamp, parseFloat(pointPrice.toFixed(4))]);
  }
  return points;
}

// Fetch helper from CoinGecko with dynamic import or global fetch
async function fetchFromCoinGecko(endpoint) {
  const url = `https://api.coingecko.com/api/v3${endpoint}`;
  const response = await fetch(url, {
    headers: {
      'Accept': 'application/json',
      'User-Agent': 'CryptoApp/1.0'
    }
  });
  if (!response.ok) {
    throw new Error(`CoinGecko HTTP ${response.status}`);
  }
  return await response.json();
}

// Routes
// 1. GET /api/coins
app.get('/api/coins', async (req, res) => {
  try {
    const search = req.query.search ? req.query.search.toLowerCase().trim() : '';
    const sortBy = req.query.sortBy || 'market_cap'; // market_cap, price, change
    const order = req.query.order || 'desc'; // asc, desc

    let coins = [];
    try {
      // Try live CoinGecko API
      const liveData = await fetchFromCoinGecko(
        '/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=true&price_change_percentage=24h'
      );
      if (Array.isArray(liveData) && liveData.length > 0) {
        coins = liveData;
      } else {
        coins = MOCK_COINS;
      }
    } catch (err) {
      console.log('Falling back to mock coins data:', err.message);
      coins = MOCK_COINS;
    }

    // Filter by search
    if (search) {
      coins = coins.filter(c =>
        c.name.toLowerCase().includes(search) ||
        c.symbol.toLowerCase().includes(search)
      );
    }

    // Sort
    coins.sort((a, b) => {
      let valA, valB;
      if (sortBy === 'price') {
        valA = a.current_price;
        valB = b.current_price;
      } else if (sortBy === 'change') {
        valA = a.price_change_percentage_24h || 0;
        valB = b.price_change_percentage_24h || 0;
      } else {
        valA = a.market_cap || 0;
        valB = b.market_cap || 0;
      }

      if (order === 'asc') {
        return valA > valB ? 1 : -1;
      } else {
        return valA < valB ? 1 : -1;
      }
    });

    res.json({ success: true, count: coins.length, data: coins });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 2. GET /api/coins/:id
app.get('/api/coins/:id', async (req, res) => {
  const coinId = req.params.id.toLowerCase();
  try {
    let coinDetail = null;
    try {
      const liveCoin = await fetchFromCoinGecko(`/coins/${coinId}?localization=false&sparkline=true`);
      if (liveCoin && liveCoin.id) {
        coinDetail = {
          id: liveCoin.id,
          symbol: liveCoin.symbol,
          name: liveCoin.name,
          image: liveCoin.image?.large || liveCoin.image?.small,
          current_price: liveCoin.market_data?.current_price?.usd || 0,
          market_cap: liveCoin.market_data?.market_cap?.usd || 0,
          market_cap_rank: liveCoin.market_cap_rank || 0,
          total_volume: liveCoin.market_data?.total_volume?.usd || 0,
          high_24h: liveCoin.market_data?.high_24h?.usd || 0,
          low_24h: liveCoin.market_data?.low_24h?.usd || 0,
          price_change_24h: liveCoin.market_data?.price_change_24h || 0,
          price_change_percentage_24h: liveCoin.market_data?.price_change_percentage_24h || 0,
          circulating_supply: liveCoin.market_data?.circulating_supply || 0,
          total_supply: liveCoin.market_data?.total_supply || 0,
          max_supply: liveCoin.market_data?.max_supply || null,
          ath: liveCoin.market_data?.ath?.usd || 0,
          description: liveCoin.description?.en ? liveCoin.description.en.split('. ')[0] + '.' : ''
        };
      }
    } catch (err) {
      console.log(`Fallback mock details for ${coinId}:`, err.message);
    }

    if (!coinDetail) {
      const mock = MOCK_COINS.find(c => c.id === coinId || c.symbol === coinId);
      if (mock) {
        coinDetail = {
          ...mock,
          description: `${mock.name} is a leading cryptocurrency in the blockchain ecosystem.`
        };
      } else {
        return res.status(404).json({ success: false, error: 'Coin not found' });
      }
    }

    res.json({ success: true, data: coinDetail });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 3. GET /api/coins/:id/market_chart
app.get('/api/coins/:id/market_chart', async (req, res) => {
  const coinId = req.params.id.toLowerCase();
  const days = parseInt(req.query.days || '7');

  try {
    let prices = [];
    try {
      const chartData = await fetchFromCoinGecko(`/coins/${coinId}/market_chart?vs_currency=usd&days=${days}`);
      if (chartData && Array.isArray(chartData.prices)) {
        prices = chartData.prices;
      }
    } catch (err) {
      console.log(`Fallback mock chart for ${coinId}:`, err.message);
    }

    if (!prices || prices.length === 0) {
      const mock = MOCK_COINS.find(c => c.id === coinId || c.symbol === coinId);
      const currentPrice = mock ? mock.current_price : 100;
      prices = generateChartPoints(currentPrice, days);
    }

    res.json({ success: true, prices });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 4. GET /api/global
app.get('/api/global', async (req, res) => {
  try {
    let globalStats = null;
    try {
      const liveGlobal = await fetchFromCoinGecko('/global');
      if (liveGlobal && liveGlobal.data) {
        const d = liveGlobal.data;
        globalStats = {
          active_cryptocurrencies: d.active_cryptocurrencies || 14850,
          total_market_cap_usd: d.total_market_cap?.usd || 2380000000000,
          total_volume_24h_usd: d.total_volume?.usd || 72500000000,
          market_cap_change_percentage_24h_usd: d.market_cap_change_percentage_24h_usd || 1.42,
          bitcoin_dominance: d.market_cap_percentage?.btc || 53.15,
          ethereum_dominance: d.market_cap_percentage?.eth || 17.56
        };
      }
    } catch (err) {
      console.log('Fallback mock global stats:', err.message);
    }

    if (!globalStats) {
      globalStats = MOCK_GLOBAL;
    }

    res.json({ success: true, data: globalStats });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 5. GET /health
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'Crypto Research Backend', timestamp: new Date().toISOString() });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Crypto API Backend running on http://localhost:${PORT}`);
});

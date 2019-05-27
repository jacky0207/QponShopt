module.exports = {

    validDistrictAndMall: function validDistrictAndMallService(visitor) {
        var hkIsland = ["IFC", "金鐘太古廣場", "時代廣場", "銅鑼灣世貿中心", "太古城中心", "杏花新城商場", "數碼港商場"];
        var kowloon = ["圓方", "Elements", "Harbour", "City", "海港城", "美麗華商場", "黃埔新天地", "又一城", "朗豪坊商場", "新世紀廣場", "奧海城", "MegaBox", "德福廣場商場", "荷里活廣場", "APM"];
        var newTerritories = ["荃新天地", "荃灣廣場", "悅來坊商場", "綠楊坊商場", "新都會廣場", "青衣城商場", "屯門市廣場", "東港城", "君薈坊商場", "連理街", "沙田新城市廣場", "大埔超級城"];

        if (visitor.district == 'HK Island' || 
            visitor.district == "Kowloon" || 
            visitor.district == "New Territories")
        {
            var items;
            var found = false;

            // get relative items
            if (visitor.district == 'HK Island')
            {
                items = hkIsland;
            }
            else if (visitor.district == "Kowloon")
            {
                items = kowloon;
            }
            else
            {
                items = newTerritories;
            }

            // compare to items
            for (item of items)
            {
                if (visitor.mall == item)
                {
                    found = true;
                    break;
                }
            }

            // validate whether exist
            if (!found)
            {
                return false;
            }
        
            return true;
        }
        else
        {
            return false;
        }
    },

    validImage: function validImageService(visitor) {
        var pattern = "^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$";
        return (visitor.image.match(pattern)) ? true : false;
    },

    validCoin: function validCoinService(visitor) {
        if (typeof visitor.coin == 'number')
        {
            return (typeof visitor.coin === 'number' && visitor.coin >= 0) ? true : false;
        }
        else if (typeof visitor.coin == 'string')
        {
            var pattern = "^[0-9]*$";
            return (visitor.coin.match(pattern)) ? true : false;
        }
        else
        {
            return false;
        }
    },

    validTill: function validTillService(visitor) {
        if (typeof visitor.till === 'string')
        {
            var pattern = "^(0[1-9]|1[0-2])\/(0[1-9]|[12]\\d|3[01])\/\\d{4}$";
            return (visitor.till.match(pattern) && new Date(visitor.till) >= new Date()) ? true : false;
        }
        else
        {
            return false;
        }
    },

    validQuota: function validQuotaService(visitor) {
        if (typeof visitor.coin == 'number')
        {
            return (typeof visitor.coin === 'number' && visitor.coin >= 0) ? true : false;
        }
        else if (typeof visitor.coin == 'string')
        {
            var pattern = "^[0-9]*$";
            return (visitor.coin.match(pattern)) ? true : false;
        }
        else
        {
            return false;
        }
    }

};
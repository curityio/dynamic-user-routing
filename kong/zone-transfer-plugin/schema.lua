return {
    name = "zone-transfer",
    fields = {{
        config = {
            type = "record",
            fields = {
                { eu_host = { type = "string", required = true } },
                { us_host = { type = "string", required = true } },
                { cookie_name = { type = "string", required = true } },
                { claim_name = { type = "string", required = true } }
            }
        }}
    }
}

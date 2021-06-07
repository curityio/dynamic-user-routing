return {
    name = "zone-transfer",
    fields = {{
        config = {
            type = "record",
            fields = {
                { cookie_name = { type = "string", required = true } },
                { claim_name = { type = "string", required = true } }
            }
        }}
    }
}

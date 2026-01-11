erDiagram

    PROVINCES {
        int province_id PK
        nvarchar name
    }

    CITIES {
        int city_id PK
        int province_id FK
        nvarchar name
    }

    CUSTOMERS {
        int customer_id PK
        nvarchar full_name
        nvarchar phone
        nvarchar email
        int city_id FK
        datetime created_at
        nvarchar status
    }

    FOURNISSEURS {
        int fournisseur_id PK
        nvarchar full_name
        nvarchar company_name
        nvarchar phone
        nvarchar email
        int city_id FK
        datetime created_at
        nvarchar status
    }

    PRODUCT_CATEGORIES {
        int category_id PK
        nvarchar code
        nvarchar name
    }

    PRODUCTS {
        int product_id PK
        int category_id FK
        nvarchar name
        nvarchar unit
        bit is_active
    }

    ORDERS {
        int order_id PK
        int customer_id FK
        int fournisseur_id FK
        date order_date
        nvarchar order_status
        decimal total_amount
    }

    ORDER_ITEMS {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
    }

    PAYMENTS {
        int payment_id PK
        int order_id FK
        date payment_date
        decimal amount
        nvarchar payment_method
        nvarchar payment_status
    }

    PROVINCES ||--o{ CITIES : contains
    CITIES ||--o{ CUSTOMERS : hosts
    CITIES ||--o{ FOURNISSEURS : hosts

    PRODUCT_CATEGORIES ||--o{ PRODUCTS : categorizes

    CUSTOMERS ||--o{ ORDERS : places
    FOURNISSEURS ||--o{ ORDERS : receives

    ORDERS ||--o{ ORDER_ITEMS : contains
    PRODUCTS ||--o{ ORDER_ITEMS : appears_in

    ORDERS ||--o| PAYMENTS : paid_by

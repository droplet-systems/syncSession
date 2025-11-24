# Droplet SyncSession

Droplet SyncSession is a free and open-source model/tool that allows you to **grab sessions directly from a Trello board and import them into a Roblox UI**.  
It streamlines session management for Roblox developers, making it easy to sync Trello data with in-game interfaces.

---

## ✨ Features
- 📥 **Trello Integration** – Fetch sessions directly from your Trello board.
- 🎮 **Roblox UI Import** – Automatically display sessions inside Roblox.
- ⚡ **Free & Open Source** – Available for everyone to use and contribute.
- 🔧 **Easy Setup** – Simple configuration with clear documentation.
- 🔄 **Silent Updates** – Deploy script ensures automatic updates without restarting your setup.

---

## 📖 Documentation
For full setup and configuration details, please refer to our official documentation:  
👉 [Droplet Systems SyncSession Docs](https://droplet-systems.gitbook.io/syncsession)

---

## ⚙️ Configuration Example

SyncSession requires a configuration module to connect your Trello board with Roblox.  
Below is a sample `Config.lua` you can adapt to your own project:

```lua
local Players = game:GetService("Players")

return {
    Key = "",          -- Your Trello API Key
    Token = "",        -- Your Trello Token
    BoardName = "Sessions",  -- Trello board name

    List = "Upcoming", -- Trello list to pull sessions from
    Labels = false,    -- Whether to use Trello labels

    Fields = {
        {
            Argument = "Host",
            Image = nil,
            ImageColor = Color3.new(255, 255, 255),

            GetImage = function(Value)
                local Status, Identifier = pcall(function()
                    return Players:GetUserIdFromNameAsync(Value)
                end)

                if not Status then Identifier = nil end

                if Identifier then
                    return string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=420&h=420", Identifier)
                else
                    return "rbxassetid://7072717759"
                end
            end,

            Value = "<b>%s</b> is hosting.",
            GetValue = function(Value)
                local Status, Result = pcall(function()
                    return Players:GetUserIdFromNameAsync(Value)
                end)

                if not Status then Result = nil end

                if Result then
                    return Value
                else
                    return "Unknown user"
                end
            end,
        },

        {
            Argument = "Co-Host",
            Image = nil,
            ImageColor = Color3.new(255, 255, 255),

            GetImage = function(Value)
                local Status, Identifier = pcall(function()
                    return Players:GetUserIdFromNameAsync(Value)
                end)

                if not Status then Identifier = nil end

                if Identifier then
                    return string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=420&h=420", Identifier)
                else
                    return "rbxassetid://7072717759"
                end
            end,

            Value = "<b>%s</b> is co-hosting.",
            GetValue = function(Value)
                local Status, Result = pcall(function()
                    return Players:GetUserIdFromNameAsync(Value)
                end)

                if not Status then Result = nil end

                if Result then
                    return Value
                else
                    return "Unknown user"
                end
            end,
        },
    },

    Seperator = ": ",
    Wait = 30, -- Refresh interval (seconds)
}
```

---

## 🏓 Setup Information

### 📦 Deploy Script
SyncSession uses a **Deploy Script** that requires our source code.  
Using the Deploy Script allows us to **silently update** the system without requiring you to restart the setup process.

⚠️ **Note:**  
We do not recommend directly using the source code unless you need to make changes that aren’t possible with the built‑in plugin system.  
If you use the raw source code, you will **not** receive automatic updates or bug fixes.

---

### 🚀 Setup Steps
1. **Get the Deploy Model** (link provided in documentation).
2. Move the **Deploy Script** into `ServerScriptService`.
3. Create a folder named **Boards** inside `Workspace`.
   - This folder should contain **Parts** (your actual boards).
   - The script automatically adds an interface to them on server startup.
   - Parts don’t have to be basic blocks — **Unions, MeshParts, etc.** will also work.
4. Recommended part size: **9 × 6 × 0.1**.

---

### ⚙️ HttpService Requirement
Some features rely on **HttpService**.  
To check if it’s enabled:

```lua
local HttpService = game:GetService("HttpService")
print(HttpService.HttpEnabled)
```

- If `true` is printed → HttpService is enabled ✅  
- If `false` is printed → HttpService is disabled ❌  

Make sure you have **Output** open to see the response.

---

## 🤝 Credits
- **Creator**: [@Nicklaus-s](https://github.com/Nicklaus-s)  
- **Contributor**: [@metricrb](https://github.com/metricrb)

---

## 📜 License
This project is free to use under the terms specified in the repository. Contributions are welcome!

---

## 💡 Contributing
We encourage community contributions!  
- Fork the repo  
- Create a new branch  
- Submit a pull request  

---

## 🔗 Community
Join our **Discord** to:
- Get support
- Stay updated on new free, open‑sourced products
- Connect with other developers


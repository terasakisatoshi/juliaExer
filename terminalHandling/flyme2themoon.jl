function moonbar()
    try
        print("\x1b[?25l") # hide cursor
        while true
            for 🌝 ∈ '🌑':'🌘'
                sleep(0.1)
                print(🌝)
                print('\r')
            end
        end
    finally
        print("\x1b[?25h") # unhide cursor
    end
end

moonbar()

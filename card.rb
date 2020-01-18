class Card
    attr_reader :face_value, :revealed

    def initialize(value)
        @face_value = value
        @revealed = false
    end

    def hide
        @revealed = false
    end

    def reveal
        @revealed = true
    end

    def to_s
        if @revealed == true
            @face_value.to_s
        else
            "?" 
        end
    end

    def ==(card)
        if card.is_a? Card
            @face_value == card.face_value
        elsif card == nil
            @face_value == nil
        end
    end
end
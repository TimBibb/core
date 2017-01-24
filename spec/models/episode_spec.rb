require "rails_helper"

RSpec.describe Episode, type: :model do
  let(:channel) { Fabricate(:channel) }

  describe "listed" do
    context "when the channel is listed" do
      let!(:channel) { Fabricate(:channel_with_episodes, listed: true) }

      it "returns the episodes of that channel" do
        byebug
        expect(Episode.listed.to_a).to eq(channel.episodes.to_a)
      end
    end

    context "when the channel is not listed" do
      let!(:channel) { Fabricate(:channel_with_episodes, listed: false) }

      it "does not return the episodes of that channel" do
        expect(Episode.listed.to_a).to eq([])
      end
    end
  end

  describe "not analised" do
    let!(:episodes) do
      [
        Fabricate(:episode),
        Fabricate(:episode_with_failed_audio),
        Fabricate(:episode_with_analysed_audio)
      ]
    end

    it "returns only the episodes with status" do
      expect(Episode.not_analysed).to eq(episodes.first(2))
    end
  end

  describe "next" do
    context "when there are other episodes for the channel" do
      let(:episodes) do
        [
          Fabricate(:episode, title: "Episode 005", published_at: 1.days.ago, channel: channel),
          Fabricate(:episode, title: "Episode 004", published_at: 2.days.ago, channel: channel),
          Fabricate(:episode, title: "Episode 003", published_at: 3.days.ago, channel: channel),
          Fabricate(:episode, title: "Episode 002", published_at: 4.days.ago, channel: channel),
          Fabricate(:episode, title: "Episode 001", published_at: 5.days.ago, channel: channel),
        ]
      end

      context "and there are recentest episode" do
        it "returns the next published episode" do
          expect(episodes.third.next).to eq(episodes.second)
        end
      end
    end

    context "when there are no other episodes for the same channel" do
      let!(:other_channel) { Fabricate(:channel_with_episodes) }
      let(:episode) { Fabricate(:episode, channel: channel) }

      it "returns a random episode from other channel" do
        expect(episode.next).to be_an_instance_of(Episode)
      end

      it "does not returns the same episode" do
        expect(episode.next.id).to_not eq(episode.id)
      end
    end

    context "when there are no other episodes at all" do
      let(:episode) { Fabricate(:episode, channel: channel) }

      it "returns nil" do
        expect(episode.next).to be_nil
      end
    end
  end
end
